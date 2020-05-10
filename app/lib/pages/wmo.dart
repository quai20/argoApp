import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
                imageUrl: 'http://www.ifremer.fr/erddap/tabledap/ArgoFloats.png?longitude,latitude,time&platform_number=%22' +
                      wmodata[0].toString() +
                      '%22&.draw=linesAndMarkers&.marker=5%7C5&.color=0x000000&.colorBar=KT_thermal%7C%7C%7C%7C%7C&.bgColor=0xffccccff',
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            )
          ],
        )));
  }
}
