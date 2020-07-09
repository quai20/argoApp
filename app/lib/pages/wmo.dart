import 'package:flutter/material.dart';
import 'package:Argo/pages/userpreference.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Wmo extends StatefulWidget {
  @override
  _WmoState createState() => new _WmoState();
}

class _WmoState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {       
    //Get wmo clicked from page context    
    List wmodata = ModalRoute.of(context).settings.arguments;    

    //        
    var temp = [[0.0,25.0],[10.0,26.0],[20.0,25.0],[30.0,26.0],[40.0,24.0],[50.0,25.0],[60.0,22.0]];  
    var psal = [[0.0,33.0],[10.0,33.2],[20.0,33.1],[30.0,33.5],[40.0,33.0],[50.0,32.6],[60.0,33.0]];  

    var thisseries = [
      new charts.Series<List<double>, double>(
        id: 'Temp',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (datv, _) => datv[0],
        measureFn: (datv, _) => datv[1],
        data: temp,
      ),
      new charts.Series<List<double>, double>(
        id: 'Psal',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (datv, _) => datv[0],
        measureFn: (datv, _) => datv[1],
        data: psal,
      )..setAttribute(charts.measureAxisIdKey, 'secondaryMeasureAxisId')
    ];


    //Lets build the page
    return Scaffold(
        appBar: AppBar(
            title: Text("WMO : " + wmodata[0].toString()),
            actions: <Widget>[
              //TRAJ icon to acess trajectory from a profile              
              IconButton(
                  icon: Icon(Icons.grain),
                  onPressed: () {                    
                    Navigator.pushNamed(context, '/search_result',
                          arguments: wmodata[0].toString());
                  }),
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
            // and the charts
            Container(
              height: 400,
              child:new charts.LineChart(
                thisseries, 
                animate: false,                 
                primaryMeasureAxis: new charts.NumericAxisSpec(
                  tickProviderSpec:
                    new charts.BasicNumericTickProviderSpec(desiredTickCount: 4)),
                secondaryMeasureAxis: new charts.NumericAxisSpec(
                  tickProviderSpec:
                    new charts.BasicNumericTickProviderSpec(desiredTickCount: 4))                
              )
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