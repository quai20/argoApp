import 'package:flutter/material.dart';
import 'package:Argo/pages/home.dart';
import 'package:Argo/pages/loading.dart';
import 'package:Argo/pages/wmo.dart';
import 'package:Argo/pages/wmor.dart';
import 'package:Argo/pages/update.dart';
import 'package:Argo/pages/about.dart';
import 'package:Argo/pages/argo.dart';
import 'package:Argo/pages/search.dart';
import 'package:Argo/pages/fleet.dart';
import 'package:Argo/pages/search_result.dart';
import 'package:Argo/pages/language.dart';

void main() => runApp(MaterialApp(
    theme: ThemeData(
      backgroundColor: Colors.white
      
    ),
    initialRoute: '/',
    routes: {      
      '/': (context) => Loading(targetdate:DateTime.now().subtract(new Duration(days: 2))),
      '/home': (context) => MapWidget(),   
      '/wmo': (context) => Wmo(),
      '/wmor': (context) => Wmor(),        
      '/update': (context) => Update(thisarg:ModalRoute.of(context).settings.arguments),      
      '/about': (context) => About(),
      '/argo': (context) => Argo(),   
      '/search': (context) => Search(),  
      '/fleet': (context) => Fleet(),    
      '/search_result': (context) => SearchResult(),
      '/language': (context) => Language()  
    }
));