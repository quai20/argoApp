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
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/home', (Route<dynamic> route) => false,
        arguments: LoadingScreenArguments(jsonData, widget.thisarg.center,
            widget.thisarg.zoom, widget.thisarg.date));
  }

  Future<String> makeRequest(targetdate) async {
    var tomorrow = targetdate.add(new Duration(days: 1));

    var sday = '';
    var smonth = '';
    var syear = '';
    var sdaya = '';
    var smontha = '';
    var syeara = '';

    var day = targetdate.day;
    if (day < 10) {
      sday = '0' + day.toString();
    } else {
      sday = day.toString();
    }
    var daya = tomorrow.day;
    if (daya < 10) {
      sdaya = '0' + daya.toString();
    } else {
      sdaya = daya.toString();
    }

    var month = targetdate.month;
    if (month < 10) {
      smonth = '0' + month.toString();
    } else {
      smonth = month.toString();
    }
    var montha = tomorrow.month;
    if (montha < 10) {
      smontha = '0' + montha.toString();
    } else {
      smontha = montha.toString();
    }

    syear = (targetdate.year).toString();
    syeara = (tomorrow.year).toString();

    //Elastic-search index api based
    var APIurl =
        'https://dataselection.euro-argo.eu/api/find-by-search-filtred';

    var StringJson =
        '{"criteriaList": [{"field": "startDate","values": [{"code": "' +
            syear +
            r'-' +
            smonth +
            r'-' +
            sday +
            r'T00:00:00.000+0000","code":"' +
            syear +
            r'-' +
            smonth +
            r'-' +
            sday +
            r'T00:00:00.000+0000","n":0},{"name":"' +
            syeara +
            r'-' +
            smontha +
            r'-' +
            sdaya +
            r'T00:00:00.000+0000","code":"' +
            syeara +
            r'-' +
            smontha +
            r'-' +
            sdaya +
            r'T00:00:00.000+0000","n":0}]' +
            r'}],"pagination": {"page": 1,"size": 10000,"paginated": true},' +
            r'"bboxParams": {"field":"coordinate","latTopLeft": 90.0,"lonTopLeft": -180.0,' +
            r'"latBottomRight": -90.0,"lonBottomRight": 180.0}}';

    //print(StringJson);
    var data = jsonDecode(StringJson);

    //HTTP CALL
    var client = http.Client();
    try {
      //var response = await client.post(APIurl, body: data);
      var response = await client.post(APIurl,
          headers: {'Content-type': 'application/json'},
          body: json.encode(data));
      SharedPreferencesHelper.setstatus(true);
      print(response.statusCode);
      return response.body;
    } on Exception catch (ex) {
      print('Server error: $ex');
      //load test dataset if request fails, not sure if it's a good idea
      var stringJson =
          await rootBundle.loadString('assets/ArgoFloats_testdata.json');
      SharedPreferencesHelper.setstatus(false);
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
