import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Argo/pages/userpreference.dart';

//STATELESS WIDGET (FIXED)
class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _setAppBarTitle(),
        ),
        body: Center(child: _setContent()));
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
                  return Text('About this app');
                }
                break;
              case 'francais':
                {
                  return Text('A propos de cette application');
                }
                break;
              case 'spanish':
                {
                  return Text('Sobre esta aplicación');
                }
                break;
            }
          }
        });
  }

  _setContent() {
    return FutureBuilder<String>(
        // get the language, saved in the user preferences
        future: SharedPreferencesHelper.getlanguage(),
        initialData: 'english',
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            var labels;
            switch (snapshot.data) {
              case 'english':
                {
                  labels = [
                    'This application is provided as is.',
                    'Please report any bugs, issues or new features ideas at :',
                    'For other requests, please contact :'
                  ];
                }
                break;
              case 'francais':
                {
                  labels = [
                    'Cette application est fournie telle quelle.',
                    'Merci de signaler bugs, problèmes ou demande de nouvelles fonctionnalités sur :',
                    'Pour toute autre demande, merci de contacter :'
                  ];
                }
                break;
              case 'spanish':
                {
                  labels = [
                    'Esta aplicación se proporciona "tal cual". ',
                    'Por favor, notifique cualquier error, problema o ideas de nuevas funciones en:',
                    'Para otras solicitudes, por favor, contáctese con:'
                  ];
                }
                break;
            }
            return ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/icon.png"),
                          fit: BoxFit.scaleDown)),
                ),
                Container(
                  height: 30,
                  color: Colors.white,
                  child: Text(' '),
                ),
                Container(
                  color: Colors.white,
                  child: Text(labels[0]),
                ),
                Container(
                  height: 30,
                  color: Colors.white,
                  child: Text(' '),
                ),
                Container(
                  color: Colors.white,
                  child: Text(labels[1]),
                ),
                Container(
                  color: Colors.white,
                  child: new InkWell(
                      child: new Text(
                          'https://github.com/quai20/argoApp/issues',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline)),
                      onTap: () =>
                          launch('https://github.com/quai20/argoApp/issues')),
                ),
                Container(
                  height: 30,
                  color: Colors.white,
                  child: Text(' '),
                ),
                Container(
                  color: Colors.white,
                  child: Text(labels[2]),
                ),
                Container(
                  height: 30,
                  color: Colors.white,
                  child: new InkWell(
                      child: new Text('kevin.balem@ifremer.fr',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline)),
                      onTap: () => launch('mailto:kevin.balem@ifremer.fr')),
                ),
              ],
            );
          }
        });
  }
}
