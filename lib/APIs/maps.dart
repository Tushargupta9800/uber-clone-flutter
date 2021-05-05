import 'dart:convert';

import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uberclone/Models/routes.dart';
import 'package:uberclone/Secrets/key_secrets.dart';
import 'package:uberclone/main.dart';

Future<String> myaddress(LatLng cordinates) async {
  final coordinates = new Coordinates(cordinates.latitude,cordinates.longitude);
  var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  var first = addresses.first;
  print("${first.featureName} : ${first.addressLine}");
  return first.addressLine;
}

Future<LatLng> mycoordinates(String Address) async{
  final query = Address;
  var addresses = await Geocoder.local.findAddressesFromQuery(query);
  var first = addresses.first;
  print("${first.featureName} : ${first.coordinates}");
  return LatLng(first.coordinates.latitude, first.coordinates.longitude);
}

Future<String> getEncodedString() async {

  double from_lat = from_location.position.latitude;
  double from_lon = from_location.position.longitude;
  double to_lat = to_location.position.latitude;
  double to_lon = to_location.position.longitude;

  print(from_lat.toString() + " " + from_lon.toString());
  print(to_lat.toString() + " " + to_lon.toString());
  print(from_location.address);
  print(to_location.address);

  String url = "https://graphhopper.com/api/1/route?point=" + from_lat.toString() + "," +
      from_lon.toString() + "&point=" + to_lat.toString() + "," + to_lon.toString() +
      "&vehicle=car&locale=en&calc_points=true&key=" + Graphopper_key;

  try {
     await http.get(url).then((value) async {
       Map<dynamic, dynamic> res = await jsonDecode(value.body.toString());
       print(res.toString());
       route.change_route(res["paths"][0]["points"],res["paths"][0]["distance"],res["paths"][0]["time"]);
       print("here");
       print("herre" + route.encoded_string+" "+route.distance.toString() + " "+ route.time.toString());
       return res["paths"][0]["points"];
     });
  }catch(e){
    print(e.toString());
  }
}