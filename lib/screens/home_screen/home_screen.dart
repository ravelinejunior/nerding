import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nerding/screens/dialog_box_screen/loadingDialog_screen.dart';
import 'package:nerding/screens/home_screen/components/upload_add_screen.dart';
import 'package:nerding/screens/welcome_screen/welcome_screen.dart';
import 'package:nerding/utils/global_vars.dart';

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
            } else if (snapshot.connectionState == ConnectionState.none) {
              //TODO 1: VERIFICAR SE EXISTE DADO
              return Container();
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
        return Container();
      }
    } else {
      //return null
      return Container();
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
