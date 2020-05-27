import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong/latlong.dart';

class SharedPreferencesHelper {

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
  final Map jsonData;
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