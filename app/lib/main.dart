import 'package:flutter/material.dart';
import 'package:argo_day/pages/home.dart';
import 'package:argo_day/pages/loading.dart';
import 'package:argo_day/pages/wmo.dart';
import 'package:argo_day/pages/update.dart';

void main() => runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Loading(targetdate:DateTime.now().subtract(new Duration(days: 1))),
      '/home': (context) => MapWidget(),   
      '/wmo': (context) => Wmo(),        
      '/update': (context) => Update(targetdate:ModalRoute.of(context).settings.arguments),         
    }
));