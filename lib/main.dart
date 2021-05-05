import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uberclone/Models/address.dart';
import 'package:uberclone/Models/routes.dart';
import 'package:uberclone/Models/user.dart';
import 'package:uberclone/firebase/firebase.dart';
import 'package:uberclone/screens/Authentication/login.dart';
import 'package:uberclone/screens/Authentication/register.dart';
import 'package:uberclone/screens/Map_search/drop_off_location.dart';
import 'package:uberclone/screens/book_taxi/booking.dart';
import 'package:uberclone/screens/settings/setting.dart';
import 'screens/homescreen.dart';

DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");
DatabaseReference myRide = FirebaseDatabase.instance.reference().child("Ride");
Address from_location = new Address();
Address to_location = new Address();
Routes route = new Routes();
// user thisUser = new user();
final user ThisUser = new user();
bool suggestion_token = false;
rides presentRide = rides();
rides lastRide = rides();
var map = MapType.normal;
bool didIbookTaxi  = false;
firebase fire = new firebase();
var tsnap;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Uber Clone",
      theme: ThemeData(
        fontFamily: "Brand_Regular",
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: routes,
      home: Register(),
    ),
  );
}

var routes = <String,WidgetBuilder>{
  "/login": (BuildContext context) => Login(),
  "/register": (BuildContext context) => Register(),
  "/homescreen": (BuildContext context) => HomeScreen(),
  "/dropme": (BuildContext context) => Drop_Off_Location(),
  "/booktaxi": (BuildContext context) => booking(),
  "/setting": (BuildContext context) => Setting(),
};