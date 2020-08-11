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
    Map jsonData = args.jsonData;
    LatLng center = args.center;
    DateTime displaydate = args.date;
    double zoom = args.zoom;
    var maxZoom = 6.0;
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
    for (var i = 0; i < jsonData['table']['rows'].length; i += 1) {
      var latitude = jsonData['table']['rows'][i][5];
      var longitude = jsonData['table']['rows'][i][6];
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
              color: Colors.blue[800],
              iconSize: 10.0,
              onPressed: () {
                Navigator.pushNamed(context, '/wmo', arguments: {
                  'data': jsonData['table']['rows'][i],
                  'from': 'home'
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
      appBar: new AppBar(title: _setAppBarTitle(), actions: <Widget>[
        //ADD CALENDAR
        IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              //CALENDAR HANDLING
              var now = new DateTime.now();
              //THIS IS FOR SURE A SOURCE OF ERROR FOR AN INTERNATIONAL USE
              now = now.subtract(new Duration(days: 1));

              var from = DateTime.now().subtract(new Duration(days: 10));
              DatePicker.showDatePicker(context,
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

  Future<String> definelanguage() async {
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
      }
    } else {
      return 'Demo [offline]';
    }
  }

  _setAppBarTitle() {
    return FutureBuilder<String>(
        // get the language, saved in the user preferences
        future: definelanguage(),
        initialData: ' ',
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return (Text(snapshot.data));
          }
        });
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
