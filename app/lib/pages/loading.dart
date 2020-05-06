import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  //Loading Json data
  
  Future<String> getJson() async {
    //var _markers = <Marker>[];
    var stringJson;
    var jsonData;
    try {
      stringJson = await makeRequest();
      jsonData = json.decode(stringJson);
    } on Exception catch (ex) {
      print('Erddap error: $ex');
      stringJson = await rootBundle.loadString('assets/ArgoFloats_testdata.json');
      jsonData = json.decode(stringJson);
    }

    //pushing to /home context with data argument, with pushReplacement to avoid back arrow in the home view   
     Navigator.pushReplacementNamed(context, '/home', arguments: jsonData);
  }

  Future<String> makeRequest() async {
    var targetdate = new DateTime.now();
    targetdate = targetdate.subtract(new Duration(days: 1));

    var sday = '';
    var smonth = '';
    var syear = '';

    var day = targetdate.day;

    if (day < 10) {
      sday = '0' + day.toString();
    } else {
      sday = day.toString();
    }

    var month = targetdate.month;
    if (month < 10) {
      smonth = '0' + month.toString();
    } else {
      smonth = month.toString();
    }

    syear = (targetdate.year).toString();

    var urll =
        'http://www.ifremer.fr/erddap/tabledap/ArgoFloats.json?platform_number%2Cpi_name%2Ccycle_number%2Cplatform_type%2Ctime%2Clatitude%2Clongitude&time%3E=' +
            syear +
            '-' +
            smonth +
            '-' +
            sday +
            'T00%3A00%3A00Z&time%3C=' +
            syear +
            '-' +
            smonth +
            '-' +
            sday +
            'T23%3A59%3A59Z';
    print(urll);
    var response = await http.get(urll);
    return response.body;
  }

  @override
  void initState() {
    super.initState();
    getJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Argo floats profiles'),
        ),
        backgroundColor: Colors.blue[800],
        body: Center(
            child: SpinKitFoldingCube(
          color: Colors.white,
          size: 50.0,
        )));
  }
}
