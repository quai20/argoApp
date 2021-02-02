import 'package:flutter/material.dart';
import 'package:Argo/pages/userpreference.dart';

class Fleet extends StatefulWidget {
  @override
  _FleetState createState() => new _FleetState();
}

class _FleetState extends State<StatefulWidget> {
  //Let's build the page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _setAppBarTitle(),
        ),
        //Future builder : the future parametre will be the fleet list, and in the builder we will
        //draw the listview depending of the list (in the builder, the list is snapshot.data)
        body: FutureBuilder<List<String>>(
            // get the wmofleetlist, saved in the user preferences
            future: SharedPreferencesHelper.getwmofleet(),
            initialData: List<String>(),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              return snapshot.hasData ? _buildList(snapshot.data) : Container();
            }));
  }

  //This is the built of the the listview itself, with fleetlist as input
  Widget _buildList(List<String> wmolist) {
    return new ListView.builder(
        itemCount: wmolist.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return new ListTile(
              title: Text(wmolist[index],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              trailing: Wrap(spacing: 5, children: <Widget>[
                //Let's add button to sea wmo page
                IconButton(
                    icon: Icon(Icons.grain, color: Colors.black),
                    onPressed: () {
                      //Call search page for wmolist[index]
                      Navigator.pushNamed(context, '/search_result',
                          arguments: wmolist[index]);
                    }),
                // and another one to remove wmo from fleet
                IconButton(
                    icon:
                        Icon(Icons.remove_circle_outline, color: Colors.black),
                    onPressed: () async {
                      wmolist.remove(wmolist[index]);
                      await SharedPreferencesHelper.setwmofleet(wmolist);
                      setState(() {});
                    })
              ]));
        });
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
                  return Text('My fleet');
                }
                break;
              case 'francais':
                {
                  return Text('Ma flotte');
                }
                break;
              case 'spanish':
                {
                  return Text('Mi flota');
                }
                break;
            }
          }
        });
  }
}
