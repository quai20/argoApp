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
      appBar:
          new AppBar(title: new Text('Argo floats profiles'), actions: <Widget>[
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
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
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
            DrawerHeader(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/Argo-logo.jpg"),
                        fit: BoxFit.contain)),
                child: Text("")),
            ListTile(
              title: Text('Search'),
              onTap: () {
                //Do something
              },
            ),
            ListTile(
              title: Text('About argo'),
              onTap: () {
                //Do something
              },
            ),
            ListTile(
              title: Text('About this app'),
              onTap: () {
                //Do something
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
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2000, 1, 1),
        maxTime: now, onChanged: (date) {
      //print('change $date');
    }, onConfirm: (date) {
      _set_date(date);
    }, currentTime: DateTime.now(), locale: LocaleType.fr);
  }

  void _wmopage(wmodata) {
    //passing argument to wmo context
    Navigator.pushNamed(context, '/wmo', arguments: wmodata);
  }

  void _set_date(date) {
    // how to update map markers with a spin loader during loading time ?
    print('new date : $date');
    // we should get the new json
    // here is a simple example to see if it's working
    // we should call erddap again here

    Map jsonData = {
      "table": {
        "rows": [
          [
            "1900978",
            "GREGORY C. JOHNSON",
            384,
            "APEX",
            "2020-04-30T05:28:31Z",
            -60.431,
            -95.379
          ],
          [
            "1901446",
            "GREGORY C. JOHNSON",
            339,
            "APEX",
            "2020-04-28T14:27:57Z",
            -8.152,
            66.233
          ],
          [
            "1901509",
            "GREGORY C. JOHNSON",
            314,
            "APEX",
            "2020-05-02T07:48:38Z",
            -6.067,
            59.15
          ],
          [
            "1901510",
            "GREGORY C. JOHNSON",
            324,
            "APEX",
            "2020-04-25T15:58:49Z",
            -29.784,
            36.944
          ],
          [
            "1901517",
            "GREGORY C. JOHNSON",
            324,
            "APEX",
            "2020-04-26T02:14:55Z",
            6.077,
            51.032
          ],
          [
            "1901606",
            "GREGORY C. JOHNSON",
            279,
            "APEX",
            "2020-04-28T03:35:26Z",
            -6.229,
            43.721
          ]
        ]
      }
    };
    // setstate()
    Navigator.pushReplacementNamed(context, '/home', arguments: jsonData);
    _MapWidgetState();
  }
}
