import 'package:flutter/material.dart';
import 'package:Argo/pages/userpreference.dart';
import 'package:fcharts/fcharts.dart';

class Wmo extends StatefulWidget {
  @override
  _WmoState createState() => new _WmoState();
}

class _WmoState extends State<StatefulWidget> {

  final points = [
    [10.0,25.0,33.0],
    [22.0,26.0,32.0],
    [30.0,25.0,33.1],
    [45.0,24.0,33.3],
    [50.0,23.0,32.9],
    [60.0,23.0,32.3],
    [70.0,25.0,33.0]
  ];

  @override
  Widget build(BuildContext context) {       
    //Get wmo clicked from page context    
    List wmodata = ModalRoute.of(context).settings.arguments;            
    final yAxis = new ChartAxis<double>(
      opposite: false,
      span: DoubleSpan(100.0,0.0),
      tickGenerator: AutoTickGenerator()
    );

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
              child: new LineChart(
        chartPadding: new EdgeInsets.fromLTRB(50.0, 20.0, 20.0, 30.0),
        lines: [
          // Temp line
          new Line<List<double>, double, double>(
            data: points,
            xFn: (meas) => meas[1],
            yFn: (meas) => meas[0],
            xAxis: new ChartAxis(
              span: new DoubleSpan(23.0, 26.0),                          
              tickLabelerStyle: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              paint: const PaintOptions.stroke(color: Colors.blue),
            ),
            yAxis: yAxis,            
            marker: const MarkerOptions(
              paint: const PaintOptions.fill(color: Colors.blue),
            ),
            stroke: const PaintOptions.stroke(color: Colors.blue),
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
              tickLabelerStyle: new TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            yAxis: yAxis,
            marker: const MarkerOptions(
              paint: const PaintOptions.fill(color: Colors.green),
              shape: MarkerShapes.square,
            ),
            stroke: const PaintOptions.stroke(color: Colors.green),
            legend: new LegendItem(
              paint: const PaintOptions.fill(color: Colors.green),
              text: 'Psal',
            ),
          ),
        ],
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