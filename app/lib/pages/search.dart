import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => new _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio();
  String _searchText = "";
  List wmos = new List();
  List filteredwmos = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search a float');

  _SearchState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
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
    this._getwmos();
    super.initState();
  }

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

  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List tempList = new List();
      for (int i = 0; i < filteredwmos.length; i++) {
        if (filteredwmos[i].toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(filteredwmos[i]);
        }
      }
      filteredwmos = tempList;
    }
    return ListView.builder(
      itemCount: wmos == null ? 0 : filteredwmos.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: Text(filteredwmos[index]),
          onTap: () {            
            Navigator.pushNamed(context, '/search_result', arguments: filteredwmos[index]);
          }
        );
      },
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search Example');
        filteredwmos = wmos;
        _filter.clear();
      }
    });
  }

  void _getwmos() async {
    final response = await dio
        .get('http://collab.umr-lops.fr/app/divaa/data/json/wmolist.json');
    List tempList = new List();
    for (int i = 0; i < response.data['wmolist'].length; i++) {
      tempList.add(response.data['wmolist'][i]);
    }
    setState(() {
      wmos = tempList;
      //wmos.shuffle();
      filteredwmos = wmos;
    });
  }
}