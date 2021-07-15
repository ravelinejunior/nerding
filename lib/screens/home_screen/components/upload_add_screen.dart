import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nerding/screens/dialog_box_screen/loadingDialog_screen.dart';
import 'package:toast/toast.dart';

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
        title: Text(
          next ? 'Por favor, descreva o Item.' : 'Escolha as imagens do Item',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Lobster',
            letterSpacing: 2.0,
          ),
        ),
        actions: [
          next
              ? Container()
              : ElevatedButton(
                  onPressed: () {
                    if (_imagesIO.length == 5) {
                      setState(() {
                        uploading = true;
                        next = true;
                      });
                    } else {
                      showToast(
                        'Max de 5 imagens por itens.',
                        duration: 3,
                        gravity: Toast.CENTER,
                      );
                    }
                  },
                  child: Text(
                    'Próximo',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Vareja',
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
          : Container(),
    );
  }

  void showToast(String message, {int? duration, int? gravity}) {
    Toast.show(message, context, duration: duration, gravity: gravity);
  }
}
