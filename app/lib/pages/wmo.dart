import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Argo/pages/userpreference.dart';

class Wmo extends StatefulWidget {
  @override
  _WmoState createState() => new _WmoState();
}

class _WmoState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    //Get wmo clicked from page context
    List wmodata = ModalRoute.of(context).settings.arguments;

    //Lets build the page
    return Scaffold(
        appBar: AppBar(
            title: Text("WMO : " + wmodata[0].toString()),
            actions: <Widget>[
              //For the heart icon, we use a future builder because we're gonna load fleet list
              //from user preferencies and compare our wmo to this list
              FutureBuilder<List<String>>(
                  // get the wmofleetlist, saved in the user preferences
                  future: SharedPreferencesHelper.getwmofleet(),
                  initialData: List<String>(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    //Here we call the build function with our fleet list and clicked wmo in input
                    return snapshot.hasData
                        ? _buildIcon(snapshot.data, wmodata[0].toString())
                        : Container();
                  }),
            ]),
        body: // Then we build the reste of the page with wmo info
            Center(
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
              child: Center(
                  child: Text('Cycle number : ' + wmodata[2].toString())),
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
            // and we call an erddap image with cachednetworkimage
            Container(
              height: 400,
              child: CachedNetworkImage(
                imageUrl:'http://www.ifremer.fr/erddap/tabledap/ArgoFloats.png?temp,pres,psal&platform_number=%22'
                +wmodata[0].toString()+'%22&cycle_number='+wmodata[2].toString()+'&.draw=linesAndMarkers&.marker=5%7C5&.color=0x000000&.colorBar=%7C%7C%7C%7C%7C&.bgColor=0xffccccff&.yRange=%7C%7Cfalse%7C',
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            )
          ],
        )));
  }

  //THis is the function that builds the favorite icon with wmo and fleet list iin input
  Widget _buildIcon(List<String> wmolist, String wmo) {
    if (wmolist.contains(wmo)) {      
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
