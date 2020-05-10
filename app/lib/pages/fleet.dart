import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Fleet extends StatefulWidget {
  @override
  _FleetState createState() => new _FleetState();
}

class _FleetState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My fleet"),
        ),
        body: FutureBuilder<List<String>>(
            // get the wmofleetlist, saved in the preferences
            future: SharedPreferencesHelper.getwmofleet(),
            initialData: List<String>(),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              return snapshot.hasData ? _buildList(snapshot.data) : Container();
            }));
  }

  Widget _buildList(List<String> wmolist) {    

    return new ListView.builder(
        itemCount: wmolist.length,
        itemBuilder: (BuildContext ctxt, int index) {          
          return new ListTile(
              title: Text(wmolist[index],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              trailing: IconButton(
                  icon: Icon(Icons.remove_circle_outline, color: Colors.black),
                  onPressed: () async {
                    wmolist.remove(wmolist[index]);
                    await SharedPreferencesHelper.setwmofleet(wmolist);
                    setState(() {});
                  }));
        });
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
