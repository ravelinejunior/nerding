import 'package:brasil_fields/brasil_fields.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSuccessful = false;

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
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Home'),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          },
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
    List<dynamic> urlImages;
    if (items != null) {
      if (items!.docs.isNotEmpty) {
        return StreamBuilder(
          stream: itemsRef.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return LoadingAlertDialogScreen(message: 'Loading...');
            else
              return ListView(
                children: snapshot.data!.docs
                    .map((document) {
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
                                    onTap: () {},
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
                                    onTap: () {},
                                    child: Text(
                                      document.get('userName'),
                                    ),
                                  ),
                                  trailing: document.get('Uid') == idUser
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (document.get('Uid') ==
                                                    idUser) {
                                                  setState(() {
                                                    showDialogForUpdateData(
                                                      document.id,
                                                      document.get('userName'),
                                                      document.get(
                                                          'userPhoneNumber'),
                                                      document.get('itemPrice'),
                                                      document.get('itemModel'),
                                                      document.get('itemColor'),
                                                      document
                                                          .get('description'),
                                                      document.get('address'),
                                                      _scaffoldKey
                                                          .currentContext,
                                                    );
                                                  });
                                                }
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.orange,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            InkWell(
                                              onTap: () {
                                                deleteAd(document.id);
                                              },
                                              child: Icon(Icons.delete,
                                                  color: Colors.red),
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
                                        title: document.get('itemModel'),
                                        itemColor: document.get('itemColor'),
                                        userNumber:
                                            document.get('userPhoneNumber'),
                                        description:
                                            document.get('description'),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
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
                                                      .replaceRange(
                                                          14, 16, '...')
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
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Align(
                                                  child: Text(
                                                    timeago.format(
                                                      document
                                                          .get('time')
                                                          .toDate(),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                    })
                    .toList()
                    .reversed
                    .toList(),
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

  Future<bool> showDialogForUpdateData(
    selecedtDoc,
    oldUserName,
    oldPhoneNumber,
    oldItemPrice,
    oldItemName,
    oldItemColor,
    oldItemDescription,
    oldAddress,
    currentContext,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (currentContext) => SingleChildScrollView(
        child: AlertDialog(
          title: Text(
            'Atualizar Anúncio',
            style: TextStyle(fontSize: 20, fontFamily: 'Bebas'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              TextFormField(
                initialValue: oldUserName,
                decoration: InputDecoration(
                  hintText: 'Digite seu nome',
                ),
                onChanged: (value) {
                  setState(() {
                    oldUserName = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: oldPhoneNumber,
                decoration: InputDecoration(
                  hintText: 'Digite seu telefone',
                ),
                inputFormatters: [
                  // obrigatório
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter(),
                ],
                onChanged: (value) {
                  setState(() {
                    oldPhoneNumber = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: oldItemPrice,
                decoration: InputDecoration(
                  hintText: 'Digite o preço',
                ),
                inputFormatters: [
                  // obrigatório
                  FilteringTextInputFormatter.digitsOnly,
                  RealInputFormatter(
                    centavos: true,
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    oldItemPrice = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: oldItemColor,
                decoration: InputDecoration(
                  hintText: 'Digite a cor do item',
                ),
                onChanged: (value) {
                  setState(() {
                    oldItemColor = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: oldItemName,
                decoration: InputDecoration(
                  hintText: 'Digite o modelo',
                ),
                onChanged: (value) {
                  setState(() {
                    oldItemName = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: oldItemDescription,
                decoration: InputDecoration(
                  hintText: 'Digite a descrição do item',
                ),
                onChanged: (value) {
                  setState(() {
                    oldItemDescription = value;
                  });
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
          contentPadding: const EdgeInsets.all(8),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(currentContext).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(currentContext).pop();

                final Map<String, dynamic> itemData = {
                  'userName': oldUserName,
                  'userPhoneNumber': oldPhoneNumber,
                  'itemPrice': oldItemPrice,
                  'itemModel': oldItemName,
                  'itemColor': oldItemColor,
                  'description': oldItemDescription,
                };
                itemsRef.doc(selecedtDoc).update(itemData).then(
                  (value) {
                    isSuccessful = true;
                    Fluttertoast.showToast(
                      msg: "Item atualizado com sucesso!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                ).catchError((onError) {
                  Fluttertoast.showToast(
                    msg: onError.toString(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                });
              },
              child: Text('Atualizar'),
            ),
          ],
        ),
      ),
    );
    return isSuccessful;
  }

  Future<void> deleteAd(selecedtDoc) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (currentContext) => AlertDialog(
        title: Text(
          'Deletar Anúncio',
          style: TextStyle(fontSize: 20, fontFamily: 'Bebas'),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.05,
          child: Text('Deseja realmente remover esse anúncio?'),
        ),
        contentPadding: const EdgeInsets.all(8),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(currentContext).pop();
            },
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(currentContext).pop();

              itemsRef
                  .doc(selecedtDoc)
                  .delete()
                  .then((value) => {
                        Fluttertoast.showToast(
                          msg: "Item deletado com sucesso!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        ),
                      })
                  .catchError((onError) {
                Fluttertoast.showToast(
                  msg: "Item atualizado com sucesso!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              });
            },
            child: Text('Deletar'),
          ),
        ],
      ),
    );
  }

  void getUserData() {
    userRef.doc(idUser).get().then((result) {
      setState(() {
        userImageUrl = result.data()!['imagePro'];
        getUserName = result.data()!['userName'];
        getUserAddress();
      });
    });
  }
}
