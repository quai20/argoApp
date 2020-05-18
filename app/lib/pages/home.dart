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

  //BUILD
  @override
  Widget build(BuildContext context) {
    //GETTING DATA FROM CONTEXT
    Map jsonData = ModalRoute.of(context).settings.arguments;

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
              iconSize: 15.0,
              onPressed: () {                
                Navigator.pushNamed(context, '/wmo', arguments: jsonData['table']['rows'][i]);
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
        IconButton(icon: Icon(Icons.calendar_today), onPressed: _setDate),
      ]),
      backgroundColor: Colors.blue[800],
      //ADD MAP
      body: new FlutterMap(
        options: new MapOptions(
          center: new LatLng(40.0, -8.0),
          zoom: 4.0,
          maxZoom: 5.0,
          minZoom: 3.0,
        ),
        layers: [
          new TileLayerOptions(
              //urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              urlTemplate:
                  "https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}",
              subdomains: ['a', 'b', 'c']),
          new MarkerLayerOptions(markers: _markers),
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

  _setAppBarTitle() {
    return FutureBuilder<String>(
        // get the language, saved in the user preferences
        future: SharedPreferencesHelper.getlanguage(),
        initialData: 'english',
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data) {
              case 'english':
                {
                  return Text('Argo network');
                }
                break;
              case 'francais':
                {
                  return Text('Le réseau Argo');
                }
                break;
            }
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

  //CALENDAR HANDLING
  void _setDate() {
    var now = new DateTime.now();
    //ACCESS THE YESTERDAY DATA ONLY AFTER 6am (data is updated at 5am (France))
    //THIS IS PROBABLY A SOURCE OF ERROR FOR AN INTERNATIONAL USAGE
    if (now.hour > 6) {
      now = now.subtract(new Duration(days: 1));
    } else {
      now = now.subtract(new Duration(days: 2));
    }

    var from = DateTime.now().subtract(new Duration(days: 10));
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: from,
        maxTime: now,
        onChanged: (date) {}, onConfirm: (date) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/update', (Route<dynamic> route) => false,
          arguments: date);
    }, currentTime: DateTime.now());
  }  
}

