import 'package:flutter/material.dart';
import 'package:Argo/pages/userpreference.dart';

class Language extends StatefulWidget {
  @override
  _LanguageState createState() => new _LanguageState();
}

class _LanguageState extends State<StatefulWidget> {
  //Let's build the page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            //The leading icon button is cheating, to avoid rebuilding drawer after changing language
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 2);
                }),
            title: Text("Settings"),
            backgroundColor: Color(0xff325b84)),
        //Future builder : the future parametre will be the user language, and in the builder we will
        //draw the listview depending of language saved in the pref
        body: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
          Container(
            height: 30,
            color: Colors.white,
            child: Text('Language', style: TextStyle(fontSize: 20)),
          ),
          Container(
            height: 200,
            color: Colors.white,
            child: FutureBuilder<String>(
                // get the language, saved in the user preferences
                future: SharedPreferencesHelper.getlanguage(),
                initialData: 'english',
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return snapshot.hasData
                      ? _buildList(snapshot.data)
                      : Container();
                }),
          ),
          Container(
            height: 30,
            color: Colors.white,
            child: Text('Map provider', style: TextStyle(fontSize: 20)),
          ),
          Container(
            height: 200,
            color: Colors.white,
            child: FutureBuilder<String>(
                // get the language, saved in the user preferences
                future: SharedPreferencesHelper.getMapProvider(),
                initialData:
                    'https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}',
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return snapshot.hasData
                      ? _buildProviderList(snapshot.data)
                      : Container();
                }),
          )
        ]));
  }

  //This is the built of the the listview itself, with fleetlist as input
  Widget _buildList(String language) {
    var icon_en = Icons.radio_button_unchecked;
    var icon_fr = Icons.radio_button_unchecked;
    var icon_es = Icons.radio_button_unchecked;

    switch (language) {
      case 'english':
        {
          icon_en = Icons.radio_button_checked;
        }
        break;

      case 'francais':
        {
          icon_fr = Icons.radio_button_checked;
        }
        break;

      case 'spanish':
        {
          icon_es = Icons.radio_button_checked;
        }
        break;
    }

    return new ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ListTile(
            leading: CircleAvatar(
                backgroundImage: AssetImage("assets/flags/uk.png")),
            title: Text('English'),
            trailing: IconButton(
                icon: Icon(icon_en),
                onPressed: () {
                  //set language & rebuild
                  SharedPreferencesHelper.setlanguage('english');
                  setState(() {});
                })),
        ListTile(
            leading: CircleAvatar(
                backgroundImage: AssetImage("assets/flags/fr.png")),
            title: Text('Francais'),
            trailing: IconButton(
                icon: Icon(icon_fr),
                onPressed: () {
                  //set language & rebuild
                  SharedPreferencesHelper.setlanguage('francais');
                  setState(() {});
                })),
        ListTile(
            leading: CircleAvatar(
                backgroundImage: AssetImage("assets/flags/es.png")),
            title: Text('Español'),
            trailing: IconButton(
                icon: Icon(icon_es),
                onPressed: () {
                  //set language & rebuild
                  SharedPreferencesHelper.setlanguage('spanish');
                  setState(() {});
                }))
      ],
    );
  }

  Widget _buildProviderList(String mapprovider) {
    var icon_mp1 = Icons.radio_button_unchecked;
    var icon_mp2 = Icons.radio_button_unchecked;
    var icon_mp3 = Icons.radio_button_unchecked;

    switch (mapprovider) {
      case 'https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}':
        {
          icon_mp1 = Icons.radio_button_checked;
        }
        break;

      case 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Physical_Map/MapServer/tile/{z}/{y}/{x}':
        {
          icon_mp2 = Icons.radio_button_checked;
        }
        break;

      case 'https://server.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer/tile/{z}/{y}/{x}':
        {
          icon_mp3 = Icons.radio_button_checked;
        }
        break;
    }

    return new ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ListTile(
            title: Text('Esri WorldGrayCanvas'),
            trailing: IconButton(
                icon: Icon(icon_mp1),
                onPressed: () {
                  //set provider & rebuild
                  SharedPreferencesHelper.setMapProvider(
                      'https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}');
                  setState(() {});
                })),
        ListTile(
            title: Text('Esri WorldPhysical'),
            trailing: IconButton(
                icon: Icon(icon_mp2),
                onPressed: () {
                  //set language & rebuild
                  SharedPreferencesHelper.setMapProvider(
                      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Physical_Map/MapServer/tile/{z}/{y}/{x}');
                  setState(() {});
                })),
        ListTile(
            title: Text('Esri OceanBasemap'),
            trailing: IconButton(
                icon: Icon(icon_mp3),
                onPressed: () {
                  //set language & rebuild
                  SharedPreferencesHelper.setMapProvider(
                      'https://server.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer/tile/{z}/{y}/{x}');
                  setState(() {});
                }))
      ],
    );
  }
}
