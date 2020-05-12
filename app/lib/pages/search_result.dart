import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        appBar: AppBar(title: Text("Float : " + wmo), actions: <Widget>[
          FutureBuilder<List<String>>(
              // get the wmofleetlist, saved in the preferences
              future: SharedPreferencesHelper.getwmofleet(),
              initialData: List<String>(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                    //Future builder for the favorite icon
                return snapshot.hasData
                    ? _buildIcon(snapshot.data, wmo)
                    : Container();
              }),
        ]),
        body: Center(
            child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            //For the wmo info, here we call erddap, so --> future builder
            FutureBuilder<List>(
                // get the wmoinfos, via an erddap function
                future: fetchInfos(wmo),
                initialData: [
                  "...",
                  "...",
                  0,
                  "TYPE",
                  "0000-00-00T00:00:00Z"
                ],
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  //here we call the function that will build the body of the page, with wmo info and images
                  return snapshot.hasData
                      ? _buildListview(snapshot.data)
                      : Container();
                }),
          ],
        )));
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

  //Function that builds the body of the page, a List view with text info and pictures
  Widget _buildListview(List wmoinfo) {
    return SizedBox(
      height: 600,
      child:ListView(padding: const EdgeInsets.all(8), children: <Widget>[
      Container(
        height: 40,
        color: Colors.red[200],
        child: Center(child: Text('PI name : ' + wmoinfo[1])),
      ),
      Container(
        height: 40,
        color: Colors.amber[200],
        child: Center(child: Text('Cycle number : ' + wmoinfo[2].toString())),
      ),
      Container(
        height: 40,
        color: Colors.cyan[200],
        child: Center(child: Text('Float type : ' + wmoinfo[3])),
      ),
      Container(
        height: 40,
        color: Colors.green[200],
        child: Center(child: Text('Profile date : ' + wmoinfo[4])),
      ),
      Container(
        height: 10,
        color: Colors.white,
        child: Center(child: Text('')),
      ),
      Container(
        height: 400,
        child: CachedNetworkImage(
          imageUrl:
              'http://www.ifremer.fr/erddap/tabledap/ArgoFloats.png?longitude,latitude,time&platform_number=%22' +
                  wmoinfo[0].toString() +
                  '%22&.draw=linesAndMarkers&.marker=5%7C5&.color=0x000000&.colorBar=KT_thermal%7C%7C%7C%7C%7C&.bgColor=0xffccccff',
          placeholder: (context, url) => new CircularProgressIndicator(),
          errorWidget: (context, url, error) => new Icon(Icons.error),
        ),
      )
    ]));
  }

  //Future function that call erddap and fetch wmo information, wmo is returned in a futur builder
  Future<List> fetchInfos(wmo) async {
    var urll =
        'http://www.ifremer.fr/erddap/tabledap/ArgoFloats.json?platform_number%2Cpi_name%2Ccycle_number%2Cplatform_type%2Ctime&platform_number=%22' +
            wmo +
            '%22&orderByMax(%22cycle_number%22)';
    //print(urll);
    final response = await http.get(urll);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.       
      var jsonData = json.decode(response.body);
      return jsonData['table']['rows'][0];
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      var jsonData = json.decode(
          '{"table": {"rows": [["7900905", "Steve Rintoul", 15, "APEX", "2020-05-01T15:58:49Z"]]}}');
      return jsonData['table']['rows'][0];
    }
  }
}

class SharedPreferencesHelper {
  // Instantiation of the SharedPreferences library
  static final String _kwmofleet = "wmofleet";

  // Method that returns the saved wmos, or empty list if none  
  static Future<List<String>> getwmofleet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_kwmofleet) ?? List<String>();
  }

  // Method that saves the fleet  
  static Future<bool> setwmofleet(List<String> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(_kwmofleet, value);
  }
}
