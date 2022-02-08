import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong/latlong.dart';

class SharedPreferencesHelper {
  //CONNECTION STATUS
  // Instantiation of the SharedPreferences library
  static final String _kstatus = "isconnected";

  // Method that returns the net status
  static Future<bool> getstatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //default true
    return prefs.getBool(_kstatus) ?? true;
  }

  // Method that saves the net status
  static Future<bool> setstatus(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_kstatus, value);
  }

// MAP PROVIDER
  // Instantiation of the SharedPreferences library
  static final String _kprovider = "mapprovider";

  // Method that returns the saved map provider
  static Future<String> getMapProvider() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //default
    return prefs.getString(_kprovider) ??
        "https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}";
  }

  // Method that saves the map provider
  static Future<bool> setMapProvider(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_kprovider, value);
  }

  // LANGUAGE
  // Instantiation of the SharedPreferences library
  static final String _klanguage = "userlanguage";

  // Method that returns the saved language
  static Future<String> getlanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //default english
    return prefs.getString(_klanguage) ?? "english";
  }

  // Method that saves the user language
  static Future<bool> setlanguage(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_klanguage, value);
  }

  // WMO LIST
  // Instantiation of the SharedPreferences library
  static final String _kwmofleet = "wmofleet";

  // Method that returns the saved wmos, or empty list if none
  static Future<List<String>> getwmofleet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_kwmofleet) ?? List<String>();
  }

  // Method that saves the fleet
  static Future<bool> setwmofleet(List<String> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(_kwmofleet, value);
  }
}

class LoadingScreenArguments {
  final List jsonData;
  final LatLng center;
  final double zoom;
  final DateTime date;
  LoadingScreenArguments(this.jsonData, this.center, this.zoom, this.date);
}

class HomeScreenArguments {
  final DateTime date;
  final LatLng center;
  final double zoom;
  HomeScreenArguments(this.date, this.center, this.zoom);
}
