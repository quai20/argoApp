import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wmo extends StatefulWidget {
  @override
  _WmoState createState() => new _WmoState();
}

class _WmoState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    //Get wmo clicked
    List wmodata = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
            title: Text("Float : " + wmodata[0].toString()),
            actions: <Widget>[
              FutureBuilder<List<String>>(
                  // get the wmofleetlist, saved in the preferences
                  future: SharedPreferencesHelper.getwmofleet(),
                  initialData: List<String>(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    return snapshot.hasData
                        ? _buildIcon(snapshot.data, wmodata[0].toString())
                        : Container();
                  }),
            ]),
        body: Center(
            child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
              height: 40,
              color: Colors.red[200],
              child: Center(child: Text('PI name : ' + wmodata[1])),
            ),
            Container(
              height: 40,
              color: Colors.amber[200],
              child:
                  Center(child: Text('Cycle numer : ' + wmodata[2].toString())),
            ),
            Container(
              height: 40,
              color: Colors.cyan[200],
              child: Center(child: Text('Float type : ' + wmodata[3])),
            ),
            Container(
              height: 40,
              color: Colors.green[200],
              child: Center(child: Text('Profile date : ' + wmodata[4])),
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
                        wmodata[0].toString() +
                        '%22&.draw=linesAndMarkers&.marker=5%7C5&.color=0x000000&.colorBar=KT_thermal%7C%7C%7C%7C%7C&.bgColor=0xffccccff',
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            )
          ],
        )));
  }

  Widget _buildIcon(List<String> wmolist, String wmo) {
    if (wmolist.contains(wmo)) {
      //return Icon(Icons.favorite, color: Colors.red);
      return IconButton(
          icon: Icon(Icons.favorite, color: Colors.red),
          onPressed: () async {
            wmolist.remove(wmo);
            await SharedPreferencesHelper.setwmofleet(wmolist);
            setState(() {});
          });
    } else {
      return IconButton(
          icon: Icon(Icons.favorite, color: Colors.white),
          onPressed: () async {
            wmolist.add(wmo);
            await SharedPreferencesHelper.setwmofleet(wmolist);
            setState(() {});
          });
    }    
  }
}

class SharedPreferencesHelper {
  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _kwmofleet = "wmofleet";

  /// ------------------------------------------------------------
  /// Method that returns the saved wmos, or empty list if none
  /// ------------------------------------------------------------
  static Future<List<String>> getwmofleet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_kwmofleet) ?? List<String>();
  }

  /// ----------------------------------------------------------
  /// Method that saves the fleet
  /// ----------------------------------------------------------
  static Future<bool> setwmofleet(List<String> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setStringList(_kwmofleet, value);
  }
}
