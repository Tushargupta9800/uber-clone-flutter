import 'dart:async';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uberclone/APIs/maps.dart';
import 'package:uberclone/main.dart';
import 'package:uberclone/screens/Widgets/decoration.dart';
import 'package:uberclone/utils/extract_polylines.dart';

import 'Map_search/drop_off_location.dart';
import 'Widgets/loading.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{

  Position currentPosition;
  var geoLocator = Geolocator();
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController MainController;
  String pick_up_location = "Getting your location....";
  String Drop_off_location = "Where you wanna go???";
  List<Marker> myMarker = [];
  bool select_home = false;
  bool select_work = false;
  double zoom = 18;
  Set<Polyline> _polyLines = {};
  extract Extract = new extract();
  AnimationController animationController;
  Animation animation;
  Tween tween;
  bool show_container = true;
  double height = 255;
  bool loading = false;

  @override
  void initState() {
    print("in homescren");
    print(ThisUser.name);
    locatePosition();
    super.initState();

  }

  @override
  void dispose() {
    MainController.dispose();
    animationController.dispose();
    super.dispose();
  }

  void do_animation(){
      print("here");
      tween = Tween<double>(begin: 0.0, end: 1.0);
      animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 500));
      animation = tween.animate(animationController);
      animationController.forward();
      double temp_height = height;
      animation.addListener(() {
        setState(() {
          print(animation.value.toString());
          if(!show_container){
            height = temp_height - animation.value*200;
          }
          else{
            height = animation.value*200 + 55;
          }
        });
      });
  }

  void find_path(String encodedString) async {
    _polyLines.add(Polyline(
        polylineId: PolylineId("This is an route Id"),//pass any string here
        width: 3,
        geodesic: true,
        points: Extract.convertToLatLng(Extract.decodePoly(encodedString)),
        color: Colors.red));
    setState(() {});
  }

  void change_my_location() async{

    LatLng latlanPosition = from_location.position;
    CameraPosition cameraposition = new CameraPosition(target: latlanPosition, zoom: zoom);
    MainController.animateCamera(CameraUpdate.newCameraPosition(cameraposition));

  }

  void move_to_my_location(LatLng position) async{

    LatLng latlanPosition = position;
    CameraPosition cameraposition = new CameraPosition(target: latlanPosition, zoom: zoom);
    MainController.animateCamera(CameraUpdate.newCameraPosition(cameraposition));

  }
  
  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latlanPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraposition = new CameraPosition(target: latlanPosition, zoom: zoom);
    MainController.animateCamera(CameraUpdate.newCameraPosition(cameraposition));

    await myaddress(LatLng(position.latitude, position.longitude)).then((value) => from_location.address = value);
    from_location.position = latlanPosition;

    setState(() {
      pick_up_location = from_location.address;
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  set_the_state(){
    Future.delayed(Duration(milliseconds: 100)).then((value) {setState(() {});});
  }

  _handleMarker(LatLng tappedPoint){
    setState(() {
      myMarker = [];

      if(select_home){
        myMarker.add(
          Marker(
            markerId: MarkerId("Uberclone from location: " + tappedPoint.toString()),
            position: tappedPoint,
          ),
        );
        myaddress(tappedPoint).then((value) {
          print("value: " + value);
          from_location.address = value;
          pick_up_location = value;
          from_location.position = tappedPoint;
          print("from location: " + pick_up_location);
          print("from location: " + from_location.address);
          setState(() {});
        });
        if(Drop_off_location != "Where you wanna go???"){
          myMarker.add(
            Marker(
              markerId: MarkerId("Uberclone to location: " + to_location.position.toString()),
              position: to_location.position,
            ),
          );
        }
      }

      if(select_work){
        myMarker.add(
          Marker(
            markerId: MarkerId("Uberclone to location: " + tappedPoint.toString()),
            position: tappedPoint,
          ),
        );
        myaddress(tappedPoint).then((value) {
          to_location.address = value;
          Drop_off_location = value;
          to_location.position = tappedPoint;
          setState(() {});
        });
        myMarker.add(
          Marker(
            markerId: MarkerId("UberClone from location: " + from_location.position.toString()),
            position: from_location.position,
          ),
        );
      }

      if(!select_work && !select_home){

        myMarker.add(
          Marker(
            markerId: MarkerId("Uberclone to location: " + to_location.position.toString()),
            position: to_location.position,
          ),
        );

        myMarker.add(
          Marker(
            markerId: MarkerId("UberClone from location: " + from_location.position.toString()),
            position: from_location.position,
          ),
        );

        myMarker.add(
          Marker(
            markerId: MarkerId("UberClone: " + tappedPoint.toString()),
            position: tappedPoint,
          ),
        );
      }

      setState(() {});
      print(myMarker.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1;
    return new Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/images/logo1.png"),
        ),
        actions: <Widget>[
          IconButton(icon: Hero(tag: "setting", child: Icon(Icons.settings)), onPressed: (){

            Navigator.pushNamed(context, "/setting").then((value) => {
              setState((){}),
            });

          }),
        ],
        title: Text(
          "Book Taxi",
          style: TextStyle(
            fontFamily: "Brand Bold",
          ),
        ),
      ),
      body: Stack(
        children: [

          GoogleMap(
            onCameraMove: (CameraPosition cameraPosition){
                setState(() {
                  zoom = cameraPosition.zoom;
                });
            },
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 270),
            mapType: map,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController ctr){
              _controller.complete(ctr);
              MainController = ctr;
              locatePosition();
            },
            markers: Set.from(myMarker),
            onTap: _handleMarker,
            polylines: _polyLines,
          ),


          (loading)?Align(
            alignment: Alignment.center,
            child: loading2(fromcolor: Colors.blue,
                tocolor: Colors.red),
          )
              :SizedBox(height: 0,),

          Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0),topRight: Radius.circular(18.0),),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7,0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 24,right: 24,bottom: 10,top: 5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (Drop_off_location == "Where you wanna go???")?
                          Text("Where to?", style: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),):
                          SizedBox(width: 0,),
                          side_space(5.0),
                          (Drop_off_location == "Where you wanna go???")?
                          SizedBox(height: 0,):Row(
                            children: [
                              GestureDetector(
                                child: Container(
                                  child: Icon(Icons.directions,size: 40.0,color: Colors.blue,),
                                ),
                                onTap: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  await getEncodedString().then((value) {
                                    find_path(route.encoded_string);
                                  });
                                  setState(() {
                                    loading = false;
                                  });
                                },
                              ),
                              side_space(15.0),
                              GestureDetector(
                                onTap: ()async{
                                  setState(() {
                                    loading = true;
                                  });
                                  if(didIbookTaxi){
                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.error,
                                      text: "You have already booked your taxi\nYou can cancel your ride in settings",
                                    );
                                  }
                                  else {
                                    await getEncodedString().then((value) {
                                      find_path(route.encoded_string);
                                    });
                                    Navigator.pushNamed(context, "/booktaxi");
                                  }
                                  setState(() {
                                    loading = false;
                                  });
                                },
                                child: Container(
                                  child: Icon(Icons.monetization_on,size: 40.0,color: Colors.blue,),
                                ),
                              ),
                              side_space(15.0),
                            ],
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                show_container = !show_container;
                              });
                              do_animation();
                            },
                            child: Container(
                              decoration: round_corners(15.0, Colors.grey[300]),
                              child: Icon((show_container)?Icons.arrow_drop_down:Icons.arrow_drop_up,size: 40,),
                            ),
                          ),
                          side_space(5),
                        ],
                      ),
                      SizedBox(height: 15.0,),
                      GestureDetector(
                        onTap: () async {
                          myMarker = [];
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => Drop_Off_Location())).then((value) => setState((){

                            if(value == "changed"){
                              pick_up_location = from_location.address;
                              Drop_off_location = to_location.address;
                            }
                            select_home = false;
                            select_work = false;
                            change_my_location();
                          }));
                        },
                        child: Container(
                          decoration: box_decoration(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: Colors.grey,),
                                SizedBox(width: 10.0,),
                                Text("Search Drop off")
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.0,),
                      InkWell(
                        onTap: (){
                          setState(() {
                            select_work = false;
                            select_home = !select_home;
                            if(select_home){
                              move_to_my_location(from_location.position);
                              Fluttertoast.showToast(msg: "Select on map to change the location", toastLength: Toast.LENGTH_SHORT);
                              _handleMarker(from_location.position);
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 5.0),
                          decoration: round_corners(20.0, (select_home)?Colors.grey[300]:Colors.white),
                          child: Row(
                            children: [
                              Hero(
                                tag: "image",
                                  child: Icon(Icons.home, color: Colors.grey,)),
                              SizedBox(width: 12.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text("From Location"),
                                  SizedBox(height: 4.0,),
                                  Container(
                                      width: MediaQuery.of(context).size.width - 100,
                                      child: Text(
                                        pick_up_location,
                                        style: TextStyle(color: Colors.black54,fontSize: 12.0),
                                        overflow: TextOverflow.ellipsis,)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Divider(
                        height: 1.0,
                        color: Colors.grey,
                        thickness: 1.0,
                      ),
                      SizedBox(height: 10.0,),
                      InkWell(
                        onTap: (){
                          setState(() {
                            select_home = false;
                            select_work = !select_work;
                            if(select_work && Drop_off_location != "Where you wanna go???"){
                              move_to_my_location(to_location.position);
                            _handleMarker(to_location.position);
                            }
                            if(select_work){Fluttertoast.showToast(msg: "Select on map to change the location", toastLength: Toast.LENGTH_SHORT);}
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 5.0),
                          decoration: round_corners(20.0, (select_work)?Colors.grey[300]:Colors.white),
                          child: Row(
                            children: [
                              Hero(
                                  tag: "secondImage",
                                  child: Icon(Icons.work, color: Colors.grey,)),
                              SizedBox(width: 12.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("To Location"),
                                  SizedBox(height: 4.0,),
                                  Container(
                                    width: MediaQuery.of(context).size.width - 100,
                                    child: Text(Drop_off_location,
                                      style: TextStyle(color: Colors.black54,fontSize: 12.0),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          )),

        ],
      ),

    );
  }

}
