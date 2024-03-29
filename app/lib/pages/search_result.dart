import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:Argo/pages/userpreference.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class SearchResult extends StatefulWidget {
  @override
  _SearchResultState createState() => new _SearchResultState();
}

class _SearchResultState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    //Get wmo searched from context page
    String wmo = ModalRoute.of(context).settings.arguments;

    //Lets build this page like the wmo page
    return Scaffold(
      appBar: AppBar(
          title: Text("WMO : " + wmo),
          backgroundColor: Color(0xff325b84),
          actions: <Widget>[
            FutureBuilder<List<String>>(
                // get the wmofleetlist, saved in the preferences
                future: SharedPreferencesHelper.getwmofleet(),
                initialData: List<String>(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  //Future builder for the favorite icon
                  return snapshot.hasData
                      ? _buildIcon(snapshot.data, wmo)
                      : Container();
                }),
          ]),
      body: FutureBuilder<List>(
          // get the wmoinfos, via an erddap function
          future: fetchInfos(wmo),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            //here we call the function that will build the body of the page, with wmo info and images
            if (snapshot.hasData) {
              return _buildMapview(snapshot.data);
            } else {
              return Center(
                  child: SpinKitFadingCircle(
                color: Colors.blue[800],
                size: 50.0,
              ));
            }
          }),
    );
  }

  //Function that builds favorite icon with wmo and fleet list as input
  Widget _buildIcon(List<String> wmolist, String wmo) {
    if (wmolist.contains(wmo)) {
      return IconButton(
          icon: Icon(Icons.favorite, color: Colors.red),
          onPressed: () async {
            //Remove wmo from fleet list (this is async/await since it writes in a xml file)
            wmolist.remove(wmo);
            await SharedPreferencesHelper.setwmofleet(wmolist);
            setState(() {});
          });
    } else {
      return IconButton(
          icon: Icon(Icons.favorite, color: Colors.white),
          onPressed: () async {
            //Add wmo to fleet list
            wmolist.add(wmo);
            await SharedPreferencesHelper.setwmofleet(wmolist);
            setState(() {});
          });
    }
  }

  //Function that builds the body of the page, a Map view with trajectory
  Widget _buildMapview(List wmoinfo) {
    var _markers = <Marker>[];
    var _line = <LatLng>[];
    var latitude;
    var longitude;

    //TURNING DATA INTO MARKERS
    //Managing 0 longitude crossing (there's also a modification in LatLng.dart)
    for (var i = 0; i < wmoinfo.length - 1; i += 1) {
      latitude = wmoinfo[i][2];
      longitude = wmoinfo[i][3];
      if ((wmoinfo[i + 1][3] - wmoinfo[i][3]) > 180) {
        wmoinfo[i + 1][3] = wmoinfo[i + 1][3] - 360;
      }
      if ((wmoinfo[i + 1][3] - wmoinfo[i][3]) < -180) {
        wmoinfo[i + 1][3] = wmoinfo[i + 1][3] + 360;
      }
      //TRY CATCH IN CASE OF BAD LAT/LON
      try {
        _line.add(LatLng(latitude, longitude));
        _markers.add(
          Marker(
            point: new LatLng(latitude, longitude),
            builder: (ctx) => Container(
                child: IconButton(
              icon: Icon(Icons.lens),
              color: Color(0xff325b84),
              iconSize: 10.0,
              onPressed: () {
                Navigator.pushNamed(context, '/wmo', arguments: {
                  'data': {
                    'platformCode': wmoinfo[i][0],
                    'cvNumber': wmoinfo[i][1]
                  },
                  'from': 'search',
                  'position': [latitude, longitude]
                });
              },
            )),
            anchorPos: AnchorPos.align(AnchorAlign.center),
          ),
        );
      } catch (e) {
        print('Error creating marker');
      }
    }

    //Let's rebuild the last marker in red (change color inside the for loop doesn't seems to work because of the async)
    _line.add(
        LatLng(wmoinfo[wmoinfo.length - 1][2], wmoinfo[wmoinfo.length - 1][3]));
    _markers.add(
      Marker(
        point: new LatLng(
            wmoinfo[wmoinfo.length - 1][2], wmoinfo[wmoinfo.length - 1][3]),
        builder: (ctx) => Container(
            child: IconButton(
          icon: Icon(Icons.lens),
          color: Colors.red,
          iconSize: 10.0,
          onPressed: () {
            Navigator.pushNamed(context, '/wmo', arguments: {
              'data': {
                'platformCode': wmoinfo[wmoinfo.length - 1][0],
                'cvNumber': wmoinfo[wmoinfo.length - 1][1]
              },
              'from': 'search'
            });
          },
        )),
        anchorPos: AnchorPos.align(AnchorAlign.center),
      ),
    );
    // the map widget has to go in a function because of the map provider (which is a future)
    return _setThisMapContent(latitude, longitude, _line, _markers);
  }

  _setThisMapContent(latitude, longitude, _line, _markers) {
    return FutureBuilder<String>(
        // get map provider, saved in the user preferences
        future: SharedPreferencesHelper.getMapProvider(),
        initialData: ' ',
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return FlutterMap(
              options: new MapOptions(
                center: new LatLng(latitude, longitude),
                zoom: 6.0,
                interactiveFlags:
                    InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                maxZoom: 10.0,
                minZoom: 3.0,
              ),
              layers: [
                new TileLayerOptions(
                  //urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  urlTemplate: snapshot.data,
                  subdomains: ['a', 'b', 'c'],
                ),
                new PolylineLayerOptions(
                  polylines: [
                    Polyline(
                        points: _line,
                        strokeWidth: 2.0,
                        color: Color(0xff325b84)),
                  ],
                ),
                new MarkerLayerOptions(markers: _markers),
              ],
            );
          }
        });
  }

  //Future function that call erddap and fetch wmo information, wmo is returned in a futur builder
  Future<List> fetchInfos(wmo) async {
    //Get traj data
    var urll =
        'http://www.ifremer.fr/erddap/tabledap/ArgoFloats.json?platform_number%2Ccycle_number%2Clatitude%2Clongitude&platform_number=%22' +
            wmo.toString() +
            '%22&orderBy(%22cycle_number%22)';
    //print(urll);
    final response = await http.get(urll);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonData = json.decode(response.body);
      return jsonData['table']['rows'];
    } else {
      // If the server did not return a 200 OK response,
      // then throw an empty point.
      var jsonData =
          json.decode('{"table": {"rows": [["0000000", 0, 0.0, 0.0]]}}');
      return jsonData['table']['rows'];
    }
  }
}
