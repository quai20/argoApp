import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => new _SearchState();
}

class _SearchState extends State<Search> {
  //init
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio();
  String _searchText = "";
  List wmos = new List();
  List filteredwmos = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search a float');

  //Main State function, that changes the state of the widget everytime searched text changes
  _SearchState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          //on 1st click on search, searched text is empty and filtered list is the complete list
          filteredwmos = wmos;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    //Here we fetch wmo list online as soon as possible (in initstate)
    this._getwmos();
    super.initState();
  }

  //building the app bar  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(title: _appBarTitle, actions: <Widget>[
      new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      )
    ]);
  }

  //building the list
  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List tempList = new List();
      for (int i = 0; i < filteredwmos.length; i++) {
        //this is where the strcmp is done (put everything in lowercase even if we have numeric... we never know)
        if (filteredwmos[i].toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(filteredwmos[i]);
        }
      }
      //the new filteredwmos are now tempList (list that contains the searched characters)
      filteredwmos = tempList;
    }
    //The we build the actual list to diplay, with ListView
    return ListView.builder(
      itemCount: wmos == null ? 0 : filteredwmos.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: Text(filteredwmos[index]),
          onTap: () {            
            //Let's call wmo page when press on tile
            Navigator.pushNamed(context, '/search_result', arguments: filteredwmos[index]);
          }
        );
      },
    );
  }

  //Function that changes the appbar when pressed on button
  void _searchPressed() {
    //setting new state of the widget
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        //either we're not searching and we activate search mode
        this._searchIcon = new Icon(Icons.close);
        //Setting the text fied, with controller _filter and numeric keyboard
        this._appBarTitle = new TextField(
          keyboardType: TextInputType.number,
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        //or we are already searching and we want to close search mode
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search a float');
        filteredwmos = wmos;
        _filter.clear();
      }
    });
  }

  //function that retrieve wmolist from server (dio call)
  void _getwmos() async {
    final response = await dio
        .get('http://collab.umr-lops.fr/app/divaa/data/json/wmolist.json');
        //Create a new list from json, so that _filter can work with
    List tempList = new List();
    for (int i = 0; i < response.data['wmolist'].length; i++) {
      tempList.add(response.data['wmolist'][i]);
    }
    //The widget has a new state (= a new list to search in)
    setState(() {
      wmos = tempList;      
      filteredwmos = wmos;
    });
  }
}