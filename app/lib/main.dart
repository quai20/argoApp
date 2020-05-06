import 'package:flutter/material.dart';
import 'package:argo_day/pages/home.dart';
import 'package:argo_day/pages/loading.dart';
import 'package:argo_day/pages/wmo.dart';

void main() => runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Loading(),
      '/home': (context) => MapWidget(),   
      '/wmo': (context) => Wmo(),         
    }
));