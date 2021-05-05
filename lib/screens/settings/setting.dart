import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uberclone/APIs/maps.dart';
import 'package:uberclone/main.dart';
import 'package:uberclone/screens/Widgets/decoration.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cool_alert/cool_alert.dart';


class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  String _mapStyle;
  var mapVar;
  List _Maps = ["Normal", "Hybrid", "Satellite", "Terrain"];
  List<DropdownMenuItem<String>> _dropDownMenuItems;

  final Email email = Email(
    body: 'Hi developer, I found your Uber Clone Application and it looks Amazing.',
    subject: 'Uber Clone review',
    recipients: ['tushargupta9800@gmail.com'],
    isHTML: false,
  );

  @override
  void initState() {
    mapVar = map;
    _dropDownMenuItems = buildAndGetDropDownMenuItems(_Maps);
    if(map == MapType.hybrid) _mapStyle = "Hybrid";
    else if(map == MapType.normal) _mapStyle = "Normal";
    else if(map == MapType.terrain) _mapStyle = "Terrain";
    else if(map == MapType.satellite) _mapStyle = "Satellite";
    super.initState();
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List maplist) {
    List<DropdownMenuItem<String>> items = List();
    for (String M in maplist) {
      items.add(DropdownMenuItem(value: M, child: Text(M)));
    }
    return items;
  }

  void changedDropDownItem(String _map) {
    setState(() {
      _mapStyle = _map;
      if(_map == "Hybrid") mapVar = MapType.hybrid;
      else if(_map == "Normal") mapVar = MapType.normal;
      else if(_map == "Satellite") mapVar = MapType.satellite;
      else if(_map == "Terrain") mapVar = MapType.terrain;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Hero(
          tag: "setting",
          child: GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Icon(Icons.settings)),
        ),
        title: Text(
          "Settings",
        ),
        actions: [
          GestureDetector(
            onTap: (){
              setState(() {
                map = mapVar;
                Navigator.of(context).pop();
              });
            },
            child: Center(
                child: Text("Save     ",style: TextStyle(
                  fontSize: 18.0,
                ),),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Column(
              children: [
                space(10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10.0,right: 10.0),
                        width: 100,
                        height: 100,
                        color: Colors.amber,
                        child: Image.asset("assets/images/user_icon.png")
                    ),
                    Container(
                      height: 100,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      width: MediaQuery.of(context).size.width - 140,
                      color: Colors.blue[600],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ThisUser.name,style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                           overflow: TextOverflow.ellipsis,
                           maxLines: 1,
                          ),
                          Text(ThisUser.Phone,style: TextStyle(
                            fontSize: 15.0,
                          ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(ThisUser.email,style: TextStyle(
                            fontSize: 12.0,
                          ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          space(5),
                        ],
                      ),
                    ),
                  ],
                ),

                space(10),
                divider(10.0, 1),
                Row(
                  children: [
                    Text("Map Style:",style: TextStyle(
                      fontSize: 20.0,
                    ),),
                    side_space(20.0),
                    DropdownButton(
                      value: _mapStyle,
                      items: _dropDownMenuItems,
                      onChanged: changedDropDownItem,
                    ),
                  ],
                ),

                divider(10.0, 1),
                space(10.0),

                (lastRide.from_destination == null)?SizedBox(height: 0,):
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        mycoordinates(lastRide.from_destination).then((value) => {
                          from_location.change_address(from_location.address, value),
                          mycoordinates(lastRide.to_destination).then((val) => {
                            to_location.change_address(lastRide.to_destination, val),
                            setState((){
                              Navigator.of(context).pop("changed");
                            })
                          })
                        });
                      });
                    },
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width - 40,
                      color: Colors.blue[600],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                        child: Column(
                          children: [
                            Text("Last Ride",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),),
                            Row(
                              children: [
                                Text("From: ",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                                Container(
                                    width: MediaQuery.of(context).size.width - 100,
                                    child: Text(lastRide.from_destination,overflow: TextOverflow.ellipsis,)),
                              ],
                            ),
                            Row(
                              children: [
                                Text("To: ",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                                Container(
                                    width: MediaQuery.of(context).size.width - 100,
                                    child: Text(lastRide.to_destination,overflow: TextOverflow.ellipsis,)),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Fair: ",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                                Text(lastRide.fair),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                (lastRide.from_destination == null)?SizedBox(height: 0,):space(10.0),
                (lastRide.from_destination == null)?SizedBox(height: 0,):divider(10.0,1),
                (lastRide.from_destination == null)?SizedBox(height: 0,):space(10.0),

                (didIbookTaxi)?
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RaisedButton(
                        onPressed: (){
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.confirm,
                            text: "Are you Sure???\nYou want to cancel the ride",
                            onConfirmBtnTap: (){
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              setState(() {
                                didIbookTaxi = false;
                              });
                            }
                          );

                        },
                        child: Text("Cancel Ride?",style: TextStyle(
                          fontSize: 20.0,
                        ),),
                        color: Colors.red,
                      ),
                      divider(10.0, 1),
                      space(10.0),
                    ],
                  ),
                )
                    :SizedBox(height: 0,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.all(10.0),
                        width: 100,
                        height: 100,
                        color: Colors.amber,
                        child: ClipOval(
                            child: Image.asset("assets/images/aboutme/tushar.jpg",
                            fit: BoxFit.cover,
                            )),
                    ),
                    Container(
                      height: 100,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      width: MediaQuery.of(context).size.width - 140,
                      color: Colors.blue[600],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Dev: Tushar Gupta",
                            style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          space(10.0),
                          Row(
                            children: [
                              side_space(10.0),
                              GestureDetector(
                                onTap:()async {
                                      await launch('https://github.com/Tushargupta9800');
                                },
                               child: Image.asset("assets/images/aboutme/github.png",height: 30.0,width: 30.0,),
                              ),
                              side_space(20.0),
                              GestureDetector(
                                onTap:() async {
                                  await FlutterEmailSender.send(email);
                                },
                                child: Image.asset("assets/images/aboutme/gmail.png",height: 30.0,width: 30.0,),
                              ),
                              side_space(20.0),
                              GestureDetector(
                                onTap:(){
                                  launch("https://www.fiverr.com/share/3b020V");
                                },
                                child: Image.asset("assets/images/aboutme/fiverr.png",height: 30.0,width: 30.0,),
                              ),
                            ],
                          ),
                          space(5),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 10.0,
              left: 10.0,
              child: Text("Algoristy ©"),
          ),

        ],
      ),
    );
  }
}
