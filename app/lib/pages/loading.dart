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
      print("request succeeded");
      jsonData = json.decode(stringJson);
    } on Exception catch (ex) {
      print('request failed: $ex');
      SharedPreferencesHelper.setstatus(false);
      //IF SERVER ERROR, LOAD AN EXAMPLE DATASET... NOT THE BEST IDEA MAYBE
      stringJson =
          await rootBundle.loadString('assets/ArgoFloats_testdata.json');
      jsonData = json.decode(stringJson);
    }

    //pushing to /home context with data argument, with pushReplacement to avoid back arrow in the home view
    //also removing this page from the app tree, it's useless after loading
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/home', (Route<dynamic> route) => false,
        arguments: LoadingScreenArguments(
            jsonData, LatLng(40.0, -8.0), 4.0, targetdate));
  }

  //makeRequest has to return Future (and be async) to avoid getting stuck during http call
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

    var StringJson = r'{"criteriaList":[{"field":"startDate","values":[{"name":"' +
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
        r'T00:00:00.000+0000","n":0}],' +
        r'"types":["DATE"]},{"field":"globalGeoShapeField","values":[{"code":"{\"type\":\"POLYGON\",' +
        r'\"coordinates\":[[[-180,-90.0],[-180,90.0],[180,90.0],[180,-90.0],[-180,-90.0]]]}\"","name":"","n":0}],' +
        r'"types":["GEOGRAPHIC"],"options":[]}],"pagination":{"page":1,"size":10000,"isPaginated":true},"bboxParams":{"latTopLeft":90.0,"lonTopLeft":-180,' +
        r'"latBottomRight":-90.0,"lonBottomRight":180,"zoom":5},"languageEnum":"en"}';

    //print(StringJson);
    var data = jsonDecode(StringJson);

    //HTTP CALL
    var client = http.Client();
    try {
      var response = await client
          .post(APIurl,
              headers: {'Content-type': 'application/json'},
              body: json.encode(data))
          .timeout(const Duration(seconds: 5), onTimeout: () {
        print('Request time out');
        showAlertDialog(context);
        return null;
      });
      SharedPreferencesHelper.setstatus(true);
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

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("Quit"),
    onPressed: () {
      SystemNavigator.pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Data server not responding"),
    content: Text("Sorry about that, Please try again later."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
