import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nerding/screens/dialog_box_screen/loadingDialog_screen.dart';
import 'package:nerding/screens/home_screen/home_screen.dart';
import 'package:nerding/utils/global_vars.dart';

class UploadAdScreen extends StatefulWidget {
  const UploadAdScreen({Key? key}) : super(key: key);

  @override
  _UploadAdScreenState createState() => _UploadAdScreenState();
}

class _UploadAdScreenState extends State<UploadAdScreen> {
  bool uploading = false;
  bool next = false;

  double val = 0;
  String imageFile = "";
  String imageFile2 = "";
  String imageFile3 = "";
  String imageFile4 = "";
  String imageFile5 = "";
  String imageFile6 = "";

  CollectionReference? imageRef;
  CollectionReference? itensRef =
      FirebaseFirestore.instance.collection('Items');
  FirebaseStorage? imageStororage;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Reference? _reference;

  List<File> _imagesIO = [];
  List<String> urlImagesList = [];
  final picker = ImagePicker();

  String userName = "";
  String userNumber = "";
  String itemPrice = "";
  String itemModel = "";
  String itemColor = "";
  String description = "";

  @override
  void initState() {
    super.initState();
    imageRef = FirebaseFirestore.instance.collection('ImageUrl');
    getUserAddress();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            next ? 'Por favor, descreva o Item.' : 'Escolha as imagens',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'VarelaRound',
            ),
          ),
          actions: [
            next
                ? Container()
                : ElevatedButton(
                    onPressed: () {
                      if (_imagesIO.length > 1) {
                        setState(() {
                          uploading = true;
                          next = true;
                        });
                      } else {
                        showToast(
                          'Mínimo de 2 imagens por item.',
                        );
                      }
                    },
                    child: Text(
                      'Próximo',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'VarelaRound',
                      ),
                    ),
                  )
          ],
        ),
        body: next
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: InputDecoration(hintText: 'Seu nome'),
                        onChanged: (value) {
                          this.userName = value;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(hintText: 'Seu telefone'),
                        onChanged: (value) {
                          this.userNumber = value;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(hintText: 'Preço'),
                        onChanged: (value) {
                          this.itemPrice = value;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(hintText: 'Cor'),
                        onChanged: (value) {
                          this.itemColor = value;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(hintText: 'Modelo'),
                        onChanged: (value) {
                          this.itemModel = value;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration:
                            InputDecoration(hintText: 'Digite uma descrição'),
                        onChanged: (value) {
                          this.description = value;
                        },
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => LoadingAlertDialogScreen(
                                  message: 'Uploading'),
                            );

                            _uploadFile().whenComplete(() {
                              Map<String, dynamic> adData = {
                                'userName': userName,
                                'Uid': _auth.currentUser!.uid,
                                'userPhoneNumber': userNumber,
                                'itemPrice': itemPrice,
                                'itemModel': itemModel,
                                'itemColor': itemColor,
                                'urlImage': urlImagesList,
                                'description': description,
                                'imagePro': userImageUrl,
                                'lat': position!.latitude,
                                'long': position!.longitude,
                                'address': completeAddress,
                                'time': DateTime.now(),
                                'status': 'not approved',
                              };

                              itensRef!.add(adData).then((value) {
                                showToast('Item cadastrado com sucesso');
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                );
                              }).catchError((onError) {
                                showToast(onError);
                              });
                            });
                          },
                          child: Text(
                            'Enviar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              )
            : Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: GridView.builder(
                      itemCount: _imagesIO.length + 1,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return index == 0
                            ? InkWell(
                                splashColor: Colors.orangeAccent,
                                onTap: () => !uploading ? _chooseImage() : null,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.orange[50],
                                  child: Center(
                                    child: IconButton(
                                      onPressed: () =>
                                          !uploading ? _chooseImage() : null,
                                      icon: Icon(Icons.add),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(_imagesIO[index - 1]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
                  uploading
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                child: Text(
                                  'Uploading...',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              const SizedBox(height: 8),
                              CircularProgressIndicator.adaptive(
                                value: val,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.blue),
                              )
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
      ),
    );
  }

  _chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imagesIO.add(File(pickedFile?.path as String));
    });

    if (pickedFile?.path == null) retrieveLostData();
  }

  Future retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) return;

    if (response.file != null) {
      setState(() {
        _imagesIO.add(File(response.file!.path));
      });
    } else {
      print(response.file);
    }
  }

  Future _uploadFile() async {
    int i = 1;
    for (var img in _imagesIO) {
      setState(() {
        val = i / _imagesIO.length;
      });

      _reference = FirebaseStorage.instance
          .ref()
          .child('Images')
          .child(_auth.currentUser!.uid)
          .child(DateTime.now().minute.toString() +
              "/" +
              DateTime.now().day.toString() +
              "-" +
              DateTime.now().month.toString() +
              "-" +
              DateTime.now().year.toString() +
              "-" +
              DateTime.now().millisecond.toString());

      await _reference!.putFile(img).whenComplete(() async {
        await _reference!.getDownloadURL().then((value) {
          urlImagesList.add(value);
          i++;
        });
      });
    }
  }

  getUserAddress() async {
    Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    position = newPosition;
    placeMarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);

    final placeMark = placeMarks![0];

    final String newCompleteAddress =
        '${placeMark.subThoroughfare} ${placeMark.thoroughfare}, '
        '${placeMark.subThoroughfare} ${placeMark.locality}, '
        '${placeMark.subAdministrativeArea}, '
        '${placeMark.administrativeArea} ${placeMark.postalCode}, '
        '${placeMark.country}';

    completeAddress = newCompleteAddress;
    print(completeAddress);

    return completeAddress;
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Text('Deseja voltar?'),
            content: Text('Desejar finalizar o upload do item?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Não'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    next = false;
                    uploading = false;
                    Navigator.of(context).pop();
                  });
                },
                child: Text('Sim'),
              ),
              TextButton(
                onPressed: () {
                  setState(
                    () {
                      next = false;
                      uploading = false;
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    },
                  );
                },
                child: Text('Voltar Tela Inicial'),
              ),
            ],
          ),
        )) ??
        false;
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.red,
      fontSize: 16,
      textColor: Colors.white,
    );
  }
}
