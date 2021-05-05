import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Address{

  String address = "";
  LatLng position;

  Address({this.address,this.position});

  void change_address(String new_address, LatLng new_position){
    this.address = new_address;
    this.position = new_position;
  }

}