import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nerding/screens/dialog_box_screen/loadingDialog_screen.dart';

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
  FirebaseStorage? imageStororage;
  FirebaseAuth _auth = FirebaseAuth.instance;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                            builder: (context) =>
                                LoadingAlertDialogScreen(message: 'Uploading'),
                          );
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
