import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:Argo/pages/userpreference.dart';

class Update extends StatefulWidget {
  final thisarg;
  const Update({this.thisarg});

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  //Loading Json data

  getJson(targetdate) async {
    //var _markers = <Marker>[];
    var stringJson;
    var jsonData;
    try {
      stringJson = await makeRequest(targetdate);
      jsonData = json.decode(stringJson);
    } on Exception catch (ex) {
      print('Erddap error: $ex');
      stringJson =
          await rootBundle.loadString('assets/ArgoFloats_testdata.json');
      jsonData = json.decode(stringJson);
    }

    //pushing to /home context with data argument, with pushReplacement to avoid back arrow in the home view
    //Navigator.pushReplacementNamed(context, '/home', arguments: jsonData);
    Navigator.of(context).pushNamedAndRemoveUntil('/home', 
    (Route<dynamic> route) => false, 
    arguments: LoadingScreenArguments(jsonData,widget.thisarg.center,widget.thisarg.zoom, widget.thisarg.date));
  }

  Future<String> makeRequest(targetdate) async {  
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

    // var urll =
    //     'http://www.ifremer.fr/erddap/tabledap/ArgoFloats.json?platform_number%2Cpi_name%2Ccycle_number%2Cplatform_type%2Ctime%2Clatitude%2Clongitude&time%3E=' +
    //         syear +
    //         '-' +
    //         smonth +
    //         '-' +
    //         sday +
    //         'T00%3A00%3A00Z&time%3C=' +
    //         syear +
    //         '-' +
    //         smonth +
    //         '-' +
    //         sday +
    //         'T23%3A59%3A59Z';
    
    //THIS IS MUCH FASTER WITH A JSON STORE SOMEWHERE ELSE, THIS COULD BE THE TRICK, LET'S SAY GENERATE JSON FOR 10 past DAYS ON SERVERSIDE... 
    var urll='http://collab.umr-lops.fr/app/divaa/data/json/'+syear+'-'+smonth+'-'+sday+'.json';
    print(urll);

    var client = http.Client();
    try {
      var response = await client.get(urll);
      return response.body;
    } on Exception catch (ex) {
      print('Erddap error: $ex');
      var stringJson = await rootBundle.loadString('assets/ArgoFloats_testdata.json');
      return stringJson;
    } finally {
      client.close();
    }
   
  }

  @override
  void initState() {
    super.initState();    
    var targetdate = widget.thisarg.date;
    print(targetdate);
    getJson(targetdate);
  }

  @override
  Widget build(BuildContext context) {
    print("loading build");
    return Scaffold(
        //appBar: new AppBar(
        //  title: new Text('Argo floats profiles'),
        //),
        backgroundColor: Colors.white,
        body: Center(
            child: SpinKitFadingCircle(
          color: Colors.blue[800],
          size: 50.0,
        )));
  }
}