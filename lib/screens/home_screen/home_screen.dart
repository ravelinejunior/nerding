import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nerding/screens/dialog_box_screen/loadingDialog_screen.dart';
import 'package:nerding/screens/home_screen/components/upload_add_screen.dart';
import 'package:nerding/screens/image_slider_screen/image_slider_screen.dart';
import 'package:nerding/screens/welcome_screen/welcome_screen.dart';
import 'package:nerding/utils/global_vars.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  QuerySnapshot? items;
  final userRef = FirebaseFirestore.instance.collection('Users');
  final itemsRef = FirebaseFirestore.instance.collection('Items');

  @override
  void initState() {
    super.initState();

    idUser = _auth.currentUser!.uid;
    userEmail = _auth.currentUser!.email!;

    itemsRef
        .where('status', isEqualTo: 'approved')
        .orderBy('time', descending: true)
        .get()
        .then((result) {
      setState(() {
        items = result;
      });
    });

    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    double _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Home'),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _auth.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => WelcomeScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.login_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
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
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Post',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UploadAdScreen(),
          ),
        ),
      ),
    );
  }

  Widget _showItemList() {
    if (items != null) {
      if (items!.docs.isNotEmpty) {
        return FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingAlertDialogScreen(
                message: 'Loading',
              );
            } else {
              return ListView.builder(
                itemCount: items!.docs.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (_, index) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListTile(
                            leading: InkWell(
                              splashColor: Colors.orange,
                              onTap: () {},
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      items!.docs[index].get('imagePro'),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            title: InkWell(
                              onTap: () {},
                              child: Text(
                                items!.docs[index].get('userName'),
                              ),
                            ),
                            trailing: items!.docs[index].get('Uid') == idUser
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Icon(Icons.edit_outlined),
                                      ),
                                      const SizedBox(width: 20),
                                      InkWell(
                                        onDoubleTap: () {},
                                        child: Icon(Icons.delete_forever_sharp),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [],
                                  ),
                          ),
                        ),
                        InkWell(
                          onDoubleTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ImageSliderScreen(
                                  title: items!.docs[index].get('itemModel'),
                                  itemColor:
                                      items!.docs[index].get('itemColor'),
                                  userNumber:
                                      items!.docs[index].get('userPhoneNumber'),
                                  description:
                                      items!.docs[index].get('description'),
                                  lat: items!.docs[index].get('lat'),
                                  long: items!.docs[index].get('long'),
                                  address: items!.docs[index].get('address'),
                                  urlImage: items!.docs[index].get('urlImage'),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: items!.docs[index].get('urlImage')[0],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            '\$${items!.docs[index].get('itemPrice')}',
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
                                        child: Text(items!.docs[index]
                                                    .get('itemModel')
                                                    .toString()
                                                    .length >
                                                15
                                            ? items!.docs[index]
                                                .get('itemModel')
                                                .toString()
                                                .substring(0, 17)
                                                .replaceRange(14, 16, '...')
                                            : items!.docs[index]
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
                                                items!.docs[index]
                                                    .get('time')
                                                    .toDate(),
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
                    ),
                  );
                },
              );
            }
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
          child: Text('Loading...'),
        ),
      );
    }
  }

  getUserData() {
    userRef.doc(idUser).get().then((result) {
      setState(() {
        userImageUrl = result.data()!['imagePro'];
        getUserName = result.data()!['userName'];
      });
    });
  }
}
