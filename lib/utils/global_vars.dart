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
// ignore: non_constant_identifier_names
String USER_NAME = 'userName';
// ignore: non_constant_identifier_names
String UID = 'uId';
// ignore: non_constant_identifier_names
String USER_NUMBER = 'userNumber';
// ignore: non_constant_identifier_names
String IMAGE_PRO = 'imagePro';
// ignore: non_constant_identifier_names
String TIME = 'time';
// ignore: non_constant_identifier_names
String STATUS = 'status';

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
