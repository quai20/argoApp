// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'dart:convert';

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() {
    return new _MapWidgetState();
  }
}

class _MapWidgetState extends State<MapWidget> {
  
  var _markers = <Marker>[];

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    var jsonData = data['jsonData'];    
    
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
              icon: Icon(Icons.lens),
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
        appBar: new AppBar(
            title: new Text('Argo floats profiles'),
            actions: <Widget>[
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
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']),
            new MarkerLayerOptions(markers: _markers),
          ],
        ));
  }

  void _setDate() {
    //do something
    //Navigator.pushNamed(context, '/setdate');
  }

  void _wmopage(wmodata) {
    //passing argument to wmo context
    //Navigator.pushReplacementNamed(context, '/wmo', arguments: {      
    //   'wmodata': wmodata,
    // });
    Navigator.pushNamed(context, '/wmo', arguments:wmodata);
  }

}
