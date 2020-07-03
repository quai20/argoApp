import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:latlong/latlong.dart';
import 'package:Argo/pages/userpreference.dart';

class Loading extends StatefulWidget {

  final DateTime targetdate;
  const Loading({this.targetdate});

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  
  //Loading Json data in async, to do the build in the same time
  //it doesn't return anything since it pushes data to next route
  getJson(targetdate) async {    
    var stringJson;
    var jsonData;
    try {
      //CALLING makeRequest with await to wait for the answer
      stringJson = await makeRequest(targetdate);
      jsonData = json.decode(stringJson);
    } on Exception catch (ex) {
      print('Erddap error: $ex');
      //IF ERDDAP ERROR, LOAD AN EXAMPLE DATASET... NOT THE BEST IDEA MAYBE
      stringJson = await rootBundle.loadString('assets/ArgoFloats_testdata.json');
      jsonData = json.decode(stringJson);
    }
    //pushing to /home context with data argument, with pushReplacement to avoid back arrow in the home view   
    //also removing this page from the app tree, it's useless after loading
    Navigator.of(context).pushNamedAndRemoveUntil('/home', 
    (Route<dynamic> route) => false, 
    arguments: LoadingScreenArguments(jsonData,LatLng(40.0, -8.0),4.0,targetdate));
  }

  //makeRequest has to return Future (and be async) to avoid getting stuck during http call
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

    //ERDDAP URL
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

    // Erddap request send time out too often, going server side...
    var urll='http://collab.umr-lops.fr/app/divaa/data/json/'+syear+'-'+smonth+'-'+sday+'.json';
    //print(urll);
    
    //HTTP CALL
    var client = http.Client();
    try {
      var response = await client.get(urll);
      SharedPreferencesHelper.setstatus(true);
      return response.body;
    } on Exception catch (ex) {
      print('Erddap error: $ex');
      //load test dataset if request fails, not sure if it's a good idea
      var stringJson = await rootBundle.loadString('assets/ArgoFloats_testdata.json');
      SharedPreferencesHelper.setstatus(false);
      return stringJson;
    } finally {
      client.close();
    }
    
  }

  //calling getJson in in initState phase so it start to load data as soon as possible
   @override
  void initState() {   
    super.initState();     
    print(widget.targetdate); 
    getJson(widget.targetdate);
  }

  //build the loading animation that spins during data is loading
  @override
  Widget build(BuildContext context) {
    print("loading build");
    return Scaffold(
        //appBar: new AppBar(
        //  title: new Text('Argo network'),
        //),
        backgroundColor: Colors.white,
        body: Center(
            child: SpinKitFadingCircle(
          color: Colors.blue[800],
          size: 50.0,
        )));
  }
}
