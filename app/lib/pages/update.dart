import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Update extends StatefulWidget {
  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {

  //Loading Json data
  Future<String> ugetJson() async {    
      var stringJson;
      var jsonData;
    try {
      stringJson = await umakeRequest();
      jsonData = json.decode(stringJson);     
      
    } on Exception catch (ex) {
      print('Erddap error: $ex');
    }   

    //sending argument to /home context
    //Navigator.pushReplacementNamed(context, '/home', arguments: {      
    //   'jsonData': jsonData,
    // });
     Navigator.pushNamed(context, '/home', arguments:jsonData);
  }

  Future<String> umakeRequest() async {

    DateTime targetdate = ModalRoute.of(context).settings.arguments;
    print(targetdate);

    var sday='';
    var smonth='';
    var syear='';

    var day = targetdate.day;
    if(day<10) {sday = '0'+day.toString();}
    else{sday = day.toString();}

    var month = targetdate.month;
    if(month<10) {smonth = '0'+month.toString();}
    else{smonth = month.toString();}
    syear = (targetdate.year).toString();
    
    var urll =
        'http://www.ifremer.fr/erddap/tabledap/ArgoFloats.json?platform_number%2Cpi_name%2Ccycle_number%2Cplatform_type%2Ctime%2Clatitude%2Clongitude&time%3E='+syear+'-'+smonth+'-'+sday+'T00%3A00%3A00Z&time%3C='+syear+'-'+smonth+'-'+sday+'T23%3A59%3A59Z';
    var response = await http.get(urll);
    return response.body;
  }

  @override
  void initState() {
    super.initState();
    ugetJson();
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
        )
      )
    );
  } 

}