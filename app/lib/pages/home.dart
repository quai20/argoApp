import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:Argo/pages/userpreference.dart';

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => new _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  //INIT MARKER LIST
  var _markers = <Marker>[];

  MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  //BUILD
  @override
  Widget build(BuildContext context) {
    //GETTING DATA FROM CONTEXT
    LoadingScreenArguments args = ModalRoute.of(context).settings.arguments;
    List jsonData = args.jsonData;
    LatLng center = args.center;
    DateTime displaydate = args.date;
    double zoom = args.zoom;
    var maxZoom = 8.0;
    var minZoom = 2.0;
    //Must change zoom to reload map tiles... I don't know why yet, some caching issue
    if (zoom == maxZoom) {
      zoom -= 1;
    } else if (zoom == minZoom) {
      zoom += 1;
    } else {
      {
        zoom -= 1;
      }
    }

    //TURNING DATA INTO MARKERS
    for (var i = 0; i < jsonData.length; i += 1) {
      var latitude = jsonData[i]['coordinate']['lat'];
      var longitude = jsonData[i]['coordinate']['lon'];
      //TRY CATCH IN CASE OF BAD LAT/LON
      try {
        _markers.add(Marker(
          width: 30.0,
          height: 30.0,
          point: new LatLng(latitude, longitude),
          builder: (ctx) => new Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
                child: IconButton(
              icon: Icon(Icons.trip_origin),
              color: Colors.black,
              iconSize: 10.0,
              onPressed: () {
                Navigator.pushNamed(context, '/wmo', arguments: {
                  'data': jsonData[i],
                  'from': 'home',
                  'position': [latitude, longitude]
                });
              },
            )),
          ),
        ));
      } catch (e) {
        print('Error creating marker');
      }
    }

    //PAGE DISPLAY
    return new Scaffold(
      appBar: new AppBar(
          title: _setAppBarTitle(),
          backgroundColor: Color(0xff325b84),
          actions: <Widget>[
            //ADD HELP BUTTON
            IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _displayhelp(context),
                );
              },
            ),
            //ADD CALENDAR
            IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () {
                  //CALENDAR HANDLING
                  var now = new DateTime.now();
                  //THIS IS FOR SURE A SOURCE OF ERROR FOR AN INTERNATIONAL USE
                  now = now.subtract(new Duration(days: 1));

                  var from = DateTime.utc(2000, 1, 1);
                  DatePicker.showDatePicker(context,
                      locale: LocaleType.en,
                      showTitleActions: true,
                      minTime: from,
                      maxTime: now,
                      onChanged: (date) {}, onConfirm: (date) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/update', (Route<dynamic> route) => false,
                        arguments: HomeScreenArguments(
                            date, mapController.center, mapController.zoom));
                  }, currentTime: displaydate);
                }),
          ]),
      backgroundColor: Colors.blue[800],
      //ADD MAP
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: center,
          zoom: zoom,
          maxZoom: maxZoom,
          minZoom: minZoom,
        ),
        layers: [
          TileLayerOptions(
            //urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            urlTemplate:
                "https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(markers: _markers),
        ],
      ),
      //DRAWER FOR THE MENU OF THE APP
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: _setDrawer(),
      ),
    );
  }

  Future<String> definetitle() async {
    var isonline = await SharedPreferencesHelper.getstatus();
    var language = await SharedPreferencesHelper.getlanguage();

    if (isonline) {
      switch (language) {
        case 'english':
          {
            return 'Argo network';
          }
          break;
        case 'francais':
          {
            return 'Le réseau Argo';
          }
          break;
        case 'spanish':
          {
            return 'Red Argo';
          }
          break;
      }
    } else {
      return 'Demo [offline]';
    }
  }

  _setAppBarTitle() {
    return FutureBuilder<String>(
        // get the language, saved in the user preferences
        future: definetitle(),
        initialData: ' ',
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return (Text(snapshot.data));
          }
        });
  }

  // Future<LocaleType> _getLocale() async {
  //   var language = await SharedPreferencesHelper.getlanguage();
  //   switch (language) {
  //     case 'english':
  //       {
  //         return LocaleType.en;
  //       }
  //       break;
  //     case 'francais':
  //       {
  //         return LocaleType.fr;
  //       }
  //       break;
  //     case 'spanish':
  //       {
  //         return LocaleType.es;
  //       }
  //       break;
  //     default:
  //       {
  //         return LocaleType.en;
  //       }
  //   }
  // }

  Future<String> definehelptext() async {
    var language = await SharedPreferencesHelper.getlanguage();
    switch (language) {
      case 'english':
        {
          return 'What you see on the map are the argo profiles for a given day (set with the "calendar" button). That means that each blue point corresponds to a measurement that has been done on the selected date. When you click on a profile, you access some of its data and metadata. Then you can add the float in your favorites ("heart" button) or display its complete trajectory ("points" button). From the trajectory view, you can access older profiles of the float. From the app menu, you can also search a float by its platform number, find your saved floats (your fleet), or learn about the argo program. You can also change the language of the app.';
        }
        break;
      case 'francais':
        {
          return 'Ce que vous voyez sur la carte sont les profils argo pour un jour donné (défini avec le bouton "calendrier"). Cela signifie que chaque point bleu correspond à une mesure qui a été effectuée à la date sélectionnée. Lorsque vous cliquez sur un profil, vous accédez à certaines de ses données et métadonnées. Vous pouvez ensuite ajouter le flotteur dans vos favoris (bouton "coeur") ou afficher sa trajectoire complète (bouton "points"). Depuis la vue de la trajectoire, vous pouvez accéder aux anciens profils du flotteur. Dans le menu de l\'application, vous pouvez également rechercher un flotteur par son numéro de plate-forme, trouver vos flotteurs sauvegardés (votre flotte), ou vous renseigner sur le programme argo. Vous pouvez également changer la langue de l\'application.';
        }
        break;
      case 'spanish':
        {
          return 'Lo que puedes ver en el mapa son los perfiles de las boyas Argo en un día determinado (elige con el icono “Calendario”). Esto significa que cada punto azul corresponde a una medición realizada en la fecha seleccionada. Al hacer clic en un perfil, accedes a algunos de sus datos y metadatos. Después, puedes añadir la boya a “Tus favoritos” (icono “corazón”) o mostrar su trayectoria completa (icono “puntos”). Desde la vista de trayectoria, puedes acceder a perfiles más antiguos de la misma boya. Desde el menú de la aplicación, también puedes buscar una boya por su numero de plataforma, encontrar tus boyas guardadas (tu flota), u obtener más información sobre el programa Argo. También puedes cambiar el idioma de la aplicación (inglés, francés o español).';
        }
        break;
      default:
        {
          return ' ';
        }
    }
  }

  _gethelptext() {
    return FutureBuilder<String>(
        // get the language, saved in the user preferences
        future: definehelptext(),
        initialData: ' ',
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return (Text(snapshot.data));
          }
        });
  }

  Widget _displayhelp(BuildContext context) {
    return new AlertDialog(
      title: Icon(Icons.message),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_gethelptext()],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('OK'),
        ),
      ],
    );
  }

  _setDrawer() {
    return FutureBuilder<String>(
        // get the language, saved in the user preferences
        future: SharedPreferencesHelper.getlanguage(),
        initialData: 'english',
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          var labels;
          if (snapshot.hasData) {
            switch (snapshot.data) {
              case 'english':
                {
                  labels = [
                    'Search a float',
                    'My Fleet',
                    'About Argo',
                    'About this app',
                    'Language'
                  ];
                }
                break;
              case 'francais':
                {
                  labels = [
                    'Rechercher un flotteur',
                    'Ma flotte',
                    'A propos d\'Argo',
                    'A propos de cette application',
                    'Langue'
                  ];
                }
                break;
              case 'spanish':
                {
                  labels = [
                    'Busca una boya perfiladora',
                    'Mi flota',
                    'Sobre Argo',
                    'Sobre esta aplicación',
                    'Idioma'
                  ];
                }
                break;
            }
            return ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                //SPACING
                Container(
                  height: 50,
                  color: Colors.white,
                  child: Text(' '),
                ),
                //ICON
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/icon.png"),
                          fit: BoxFit.scaleDown)),
                ),
                //MENU ITEMS
                ListTile(
                  title: Text(labels[0]),
                  onTap: () {
                    Navigator.pushNamed(context, '/search');
                  },
                ),
                ListTile(
                  title: Text(labels[1]),
                  onTap: () {
                    Navigator.pushNamed(context, '/fleet');
                  },
                ),
                ListTile(
                  title: Text(labels[2]),
                  onTap: () {
                    Navigator.pushNamed(context, '/argo');
                  },
                ),
                ListTile(
                  title: Text(labels[3]),
                  onTap: () {
                    Navigator.pushNamed(context, '/about');
                  },
                ),
                ListTile(
                  title: Text(labels[4]),
                  onTap: () {
                    Navigator.pushNamed(context, '/language');
                  },
                )
              ],
            );
          }
        });
  }
}
