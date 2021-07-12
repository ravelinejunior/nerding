import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

String idUser = "";
String userEmail = "";
String userImageUrl = "";
String getUserName = "";

String adUserName = "";
String adUserImageUrl = "";

String completeAddress = "";
List<Placemark>? placeMarks;
Position? position;

//users firebase consts
String USER_NAME = 'userName';
String UID = 'uId';
String USER_NUMBER = 'userNumber';
String IMAGE_PRO = 'imagePro';
String TIME = 'time';
String STATUS = 'status';
