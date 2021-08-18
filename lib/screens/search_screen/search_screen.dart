import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nerding/screens/dialog_box_screen/loadingDialog_screen.dart';
import 'package:nerding/screens/image_slider_screen/image_slider_screen.dart';
import 'package:nerding/screens/profile_screen/profile_screen.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "";

  FirebaseAuth _auth = FirebaseAuth.instance;
  QuerySnapshot? itemsSnapshot;
  final CollectionReference itemsRef =
      FirebaseFirestore.instance.collection('Items');

  @override
  void initState() {
    super.initState();
    itemsRef
        .where('status', isEqualTo: 'approved')
        .orderBy('time', descending: true)
        .get()
        .then((result) {
      setState(() {
        itemsSnapshot = result;
      });
    });
  }

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
          child: _showItemList(),
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

  Widget _showItemList() {
    List<dynamic> urlImages;
    if (itemsSnapshot != null) {
      if (itemsSnapshot!.docs.isNotEmpty) {
        return StreamBuilder(
          stream: _searchController.text.isNotEmpty && _searchController != null
              ? itemsRef
                  .where('itemModel',
                      isGreaterThanOrEqualTo: _searchController.text.trim())
                  .snapshots()
              : itemsRef.orderBy('time', descending: true).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return LoadingAlertDialogScreen(message: 'Loading...');
            else
              return ListView(
                children: snapshot.data!.docs.map((document) {
                  urlImages = document.get('urlImage');
                  return Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: ListTile(
                              leading: InkWell(
                                splashColor: Colors.orange,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                        sellerId: document.get('Uid'),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        document.get('imagePro'),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              title: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                        sellerId: document.get('Uid'),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  document.get('userName'),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onDoubleTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ImageSliderScreen(
                                    title: document.get('itemModel'),
                                    itemColor: document.get('itemColor'),
                                    userNumber: document.get('userPhoneNumber'),
                                    description: document.get('description'),
                                    lat: document.get('lat'),
                                    long: document.get('long'),
                                    address: document.get('address'),
                                    urlImage: document.get('urlImage'),
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: CarouselSlider(
                                items: urlImages
                                    .map((image) => ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: FadeInImage.memoryNetwork(
                                            placeholder: kTransparentImage,
                                            image: image,
                                            height: 220,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.cover,
                                          ),
                                        ))
                                    .toList(),
                                options: CarouselOptions(
                                  height: 400,
                                  aspectRatio: 16 / 13,
                                  viewportFraction: 1,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: false,
                                  autoPlayInterval: Duration(seconds: 3),
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.easeInCubic,
                                  enlargeCenterPage: true,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '\$${document.get('itemPrice')}',
                              style: TextStyle(
                                fontFamily: 'Bebas',
                                letterSpacing: 1.5,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Align(
                                          child: Text(document
                                                      .get('itemModel')
                                                      .toString()
                                                      .length >
                                                  15
                                              ? document
                                                  .get('itemModel')
                                                  .toString()
                                                  .substring(0, 17)
                                                  .replaceRange(14, 16, '...')
                                              : document
                                                  .get('itemModel')
                                                  .toString()),
                                          alignment: Alignment.topLeft,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Row(
                                      children: [
                                        Icon(Icons.watch_later_outlined),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Align(
                                              child: Text(
                                                timeago.format(
                                                  document.get('time').toDate(),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              alignment: Alignment.topLeft,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ));
                }).toList(),
              );
          },
        );
      } else {
        //list empty
        return Center(
          child: Text('Lista Vazia'),
        );
      }
    } else {
      //return null
      return Container(
        child: Center(
          child: LoadingAlertDialogScreen(
            message: 'Loading',
          ),
        ),
      );
    }
  }

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
          'Result = ${itemsSnapshot!.docs[0].get('itemModel')}',
        );
      });
    });
  }
}
