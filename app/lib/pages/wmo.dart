import 'package:flutter/material.dart';

class Wmo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    List wmodata = ModalRoute.of(context).settings.arguments;
        
    return Scaffold(
        appBar: AppBar(
          title: Text("Float : " + wmodata[0].toString()),
        ),
        body: Center(
            child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
              height: 50,
              color: Colors.red[200],
              child: Center(child: Text('PI name : '+ wmodata[1])),
            ),
            Container(
              height: 50,
              color: Colors.amber[200],
              child: Center(child: Text('Cycle numer : '+ wmodata[2].toString())),
            ),
            Container(
              height: 50,
              color: Colors.cyan[200],
              child: Center(child: Text('Float type : '+ wmodata[3])),
            ),
            Container(
              height: 50,
              color: Colors.green[200],
              child: Center(child: Text('Profile date : '+ wmodata[4])),
            ),
          ],
        )));
  }
}
