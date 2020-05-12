import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//STATELESS WIDGET (FIXED)
class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("About"),
        ),
        body: Center(
            child: ListView(
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
              height: 30,
              color: Colors.white,
              child: Text('This application is provided as is.'),
            ),
            Container(
              height: 30,
              color: Colors.white,
              child: Text(
                  'Please report any bugs, issues or new features ideas at :'),
            ),
            Container(
              height: 30,
              color: Colors.white,
              child: new InkWell(
                  child: new Text('https://github.com/quai20/argoApp/issues',style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                  onTap: () => launch(
                      'https://github.com/quai20/argoApp/issues')),
            ),
            Container(
              height: 30,
              color: Colors.white,
              child: Text(' '),
            ),
            Container(
              height: 30,
              color: Colors.white,
              child: Text(
                  'For other requests, please contact :'),
            ),
            Container(
              height: 30,
              color: Colors.white,
              child: new InkWell(
                  child: new Text('kevin.balem@ifremer.fr',style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                  onTap: () => launch(
                      'mailto:kevin.balem@ifremer.fr')),
            ),
          ],
        )));
  }
}
