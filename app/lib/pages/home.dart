// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => new _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  var _markers = <Marker>[];

  @override
  Widget build(BuildContext context) {
    Map jsonData = ModalRoute.of(context).settings.arguments;

    for (var i = 0; i < jsonData['table']['rows'].length; i += 1) {
      //print(jsonData['table']['rows'][i][5]);
      var latitude = jsonData['table']['rows'][i][5];
      var longitude = jsonData['table']['rows'][i][6];
      try {
        _markers.add(Marker(
          width: 30.0,
          height: 30.0,
          point: new LatLng(latitude, longitude),
          builder: (ctx) => new Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
                child: IconButton(
              icon: Icon(Icons.details),
              color: Colors.blue[800],
              iconSize: 15.0,
              onPressed: () {
                _wmopage(jsonData['table']['rows'][i]);
              },
            )),
          ),
        ));
      } catch (e) {
        print('Error creating marker');
      }
    }

    return new Scaffold(
      appBar:
          new AppBar(title: new Text('Argo network'), actions: <Widget>[
        // Add 3 lines from here...
        IconButton(icon: Icon(Icons.calendar_today), onPressed: _setDate),
      ]),
      backgroundColor: Colors.blue[800],
      body: new FlutterMap(
        options: new MapOptions(
          center: new LatLng(35.0, 5.0),
          zoom: 5.0,
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
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 50,
              color: Colors.white,
              child: Text(' '),
            ),
            Container(
              height: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/icon.png"),
                      fit: BoxFit.scaleDown)),
            ),
            ListTile(
              title: Text('Search a float'),
              onTap: () {
                Navigator.pushNamed(context, '/search');
              },
            ),
            ListTile(
              title: Text('My fleet'),
              onTap: () {
                Navigator.pushNamed(context, '/fleet');
              },
            ),
            ListTile(
              title: Text('About argo'),
              onTap: () {
                Navigator.pushNamed(context, '/argo');
              },
            ),
            ListTile(
              title: Text('About this app'),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            )
          ],
        ),
      ),
    );
  }

  void _setDate() {
    var now = new DateTime.now();
    now = now.subtract(new Duration(days: 1));
    var from=DateTime.now().subtract(new Duration(days: 10));
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: from,
        maxTime: now, onChanged: (date) {
      //print('change $date');
    }, onConfirm: (date) {
      //_setthisdate(date);
      //Navigator.pushReplacementNamed(context, '/update', arguments: date);
      Navigator.of(context).pushNamedAndRemoveUntil('/update', (Route<dynamic> route) => false, arguments: date);
    }, currentTime: DateTime.now(), locale: LocaleType.fr);
  }

  void _wmopage(wmodata) {
    //passing argument to wmo context
    Navigator.pushNamed(context, '/wmo', arguments: wmodata);
  }
}
