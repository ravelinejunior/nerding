import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "";

  FirebaseAuth _auth = FirebaseAuth.instance;
  late QuerySnapshot itemsSnapshot;
  final CollectionReference itemsRef =
      FirebaseFirestore.instance.collection('Items');

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    double _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: _buildActions(),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepOrange[300]!,
                Colors.deepOrange,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0, 1],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: _screenWidth,
          child: _showItemsList(),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextFormField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Pesquise aqui',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white54),
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      onChanged: (query) => _updateSearchQuery(query),
    );
  }

  _buildTitle(BuildContext context) {
    return Text('Buscar Anúncio');
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          onPressed: () {
            if (_searchController == null || _searchController.text.isEmpty) {
              Navigator.of(context).pop();
              return;
            }

            _clearSearchQuery();
          },
          icon: const Icon(Icons.clear),
        )
      ];
    }
    return <Widget>[
      IconButton(
        onPressed: _startSearch,
        icon: const Icon(Icons.search),
      )
    ];
  }

  _showItemsList() {}

  _updateSearchQuery(String query) {
    setState(() {
      getResults();
      searchQuery = query;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchController.clear();
      _updateSearchQuery("");
    });
  }

  _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  _stopSearching() {
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }

  void getResults() {
    itemsRef
        .where('itemModel',
            isGreaterThanOrEqualTo: _searchController.text.trim())
        .where('status', isEqualTo: 'approved')
        .get()
        .then((snapshot) {
      setState(() {
        itemsSnapshot = snapshot;
        print(
          'Result = ${itemsSnapshot.docs[0].get('itemModel')}',
        );
      });
    });
  }
}
