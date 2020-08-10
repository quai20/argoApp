import 'package:flutter/material.dart';
import 'package:Argo/pages/userpreference.dart';
import 'package:fcharts/fcharts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:scidart/numdart.dart';

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
                child: FutureBuilder<List<List<double>>>(
                    // retrieve data
                    future: _retrievedata(
                        wmodata[0].toString(), wmodata[2].toString()),
                    initialData: [
                      [0.0, 0.0, 0.0]
                    ],
                    builder: (BuildContext context,
                        AsyncSnapshot<List<List<double>>> snapshot) {
                      //Here we call the build function
                      return snapshot.hasData
                          ? _buildChart(snapshot.data)
                          : Container();
                    }))
          ],
        )));
  }

  Widget _buildChart(points) {
    final yAxis = new ChartAxis<double>(
        opposite: false,
        span: DoubleSpan(2000.0, 0.0),
        tickGenerator:
            FixedTickGenerator(ticks: arange(start: 0, stop: 2000, step: 200)));
    return LineChart(
      chartPadding: new EdgeInsets.fromLTRB(50.0, 20.0, 20.0, 30.0),
      lines: [
        // Temp line
        new Line<List<double>, double, double>(
          data: points,
          xFn: (meas) => meas[1],
          yFn: (meas) => meas[0],
          xAxis: new ChartAxis(
              tickLabelerStyle: new TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.bold),
              paint: const PaintOptions.stroke(color: Colors.blue),
              tickGenerator: EmptyTickGenerator()),
          yAxis: yAxis,
          marker: const MarkerOptions(
              paint: const PaintOptions.fill(color: Colors.blue),
              shape: MarkerShapes.circle,
              size: 2.0),
          stroke: const PaintOptions.stroke(
              color: Colors.transparent, strokeWidth: 0.0),
          legend: new LegendItem(
            paint: const PaintOptions.fill(color: Colors.blue),
            text: 'Temp',
          ),
        ),

        // size line
        new Line<List<double>, double, double>(
          data: points,
          xFn: (meas) => meas[2],
          yFn: (meas) => meas[0],
          xAxis: new ChartAxis(
            offset: -350.0,
            paint: const PaintOptions.stroke(color: Colors.green),
            tickLabelerStyle:
                new TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            tickGenerator: EmptyTickGenerator(),
          ),
          yAxis: yAxis,
          marker: const MarkerOptions(
              paint: const PaintOptions.fill(color: Colors.green),
              shape: MarkerShapes.circle,
              size: 2.0),
          stroke: const PaintOptions.stroke(
              color: Colors.transparent, strokeWidth: 0.0),
          legend: new LegendItem(
            paint: const PaintOptions.fill(color: Colors.green),
            text: 'Psal',
          ),
        ),
      ],
    );
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

Future<List<List<double>>> _retrievedata(wmo, cycle) async {
  String stringJson;
  var jsonData;

  var urll =
      'http://www.ifremer.fr/erddap/tabledap/ArgoFloats.json?pres%2Ctemp%2Cpsal&platform_number=%22' +
          wmo +
          '%22&cycle_number=' +
          cycle +
          '&orderBy(%22pres%22)';

  var client = http.Client();
  try {
    //CALLING makeRequest with await to wait for the answer
    var response = await client.get(urll);
    stringJson = response.body;

    jsonData = json.decode(stringJson);
    List<List<double>> bigList = [];

    for (var e in jsonData['table']['rows']) {
      List<double> smallList = [];
      for (var j in e) {
        smallList.add(j.toDouble());
      }
      bigList.add(smallList);
    }
    return bigList;
  } on Exception catch (ex) {
    print('Erddap error: $ex');
    return [
      [0.0, 0.0, 0.0]
    ];
  } finally {
    client.close();
  }
}
