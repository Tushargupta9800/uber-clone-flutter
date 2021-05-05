import 'dart:math';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:uberclone/Models/taxiList.dart';
import 'package:uberclone/main.dart';
import 'package:uberclone/screens/Widgets/decoration.dart';
import 'package:uberclone/screens/Widgets/loading.dart';


class booking extends StatefulWidget {
  @override
  _bookingState createState() => _bookingState();
}

class _bookingState extends State<booking> {
  
  var rand = new Random();
  String dimension;
  String timeExtension;
  List<taxiList> myTaxi;
  bool loading = false;

  @override
  void initState() {

    dimension = (route.m)?"m":"km";
    timeExtension = (route.min)?"min":"hr";

    myTaxi = [
      taxiList(Image: "assets/images/taxi/clonex.png", Model: "Clone X",Fair: (route.m)?((route.distance.toInt() + rand.nextInt(50))/100):(route.distance*5 + rand.nextInt(10))),
      taxiList(Image: "assets/images/taxi/clonepool.png", Model: "Clone Pool",Fair: (route.m)?((route.distance.toInt() + rand.nextInt(50))/100):(route.distance*5 + rand.nextInt(10))),
      taxiList(Image: "assets/images/taxi/clonexl.png", Model: "Clone XL",Fair: (route.m)?((route.distance.toInt()*2 + rand.nextInt(50))/100):(route.distance*6 + rand.nextInt(15))),
      taxiList(Image: "assets/images/taxi/clonesuv.png", Model: "Clone SUV",Fair: (route.m)?((route.distance.toInt()*2 + rand.nextInt(50))/100):(route.distance*6 + rand.nextInt(15))),
      taxiList(Image: "assets/images/taxi/cloneselect.png", Model: "Clone Select",Fair: (route.m)?((route.distance.toInt()*3 + rand.nextInt(50))/100):(route.distance*7 + rand.nextInt(18))),
      taxiList(Image: "assets/images/taxi/cloneblack.png", Model: "Clone Black",Fair: (route.m)?((route.distance.toInt()*3 + rand.nextInt(50))/100):(route.distance*7 + rand.nextInt(18))),
      taxiList(Image: "assets/images/taxi/clonelux.png", Model: "Clone Lux",Fair: (route.m)?((route.distance.toInt()*3 + rand.nextInt(100))/100):(route.distance*8 + rand.nextInt(20))),
      taxiList(Image: "assets/images/taxi/clonewav.png", Model: "Clone Wav",Fair: (route.m)?((route.distance.toInt()*3 + rand.nextInt(100))/100):(route.distance*8 + rand.nextInt(20))),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Book Taxi",
          style: TextStyle(
            fontFamily: "Brand Bold",
          ),
        ),
      ),

      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        color: Colors.blue[800],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: MediaQuery.of(context).size.width-100,
                          height: 150,
                          decoration: box_decoration(),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0,right: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("From: " + from_location.address,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                space(6),
                                Text("To: " + to_location.address,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                space(6),
                                Text("Distance: " + (route.distance).toStringAsFixed(2) + " " + dimension),
                                Text("Average Time: " + route.time + timeExtension),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height-300,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: myTaxi.length,
                  itemBuilder: (context,index){
                    return Card(
                      child: Container(
                        margin: EdgeInsets.only(top: 10.0,bottom: 10.0),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        color: (index%2 == 1)?Colors.blue[500]:Colors.blue[200],
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                width: 150,
                                child: Image.asset(myTaxi[index].Image)),
                            side_space(50.0),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(myTaxi[index].Model,style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),),

                                Text("₹" +myTaxi[index].Fair.toStringAsFixed(2),style: TextStyle(
                                  fontSize: 20.0,
                                  fontStyle: FontStyle.italic,
                                ),),


                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    await presentRide.add_rides(from_location.address, to_location.address, myTaxi[index].Fair.toStringAsFixed(2),myTaxi[index].Image);
                                    await lastRide.add_rides(from_location.address, to_location.address, myTaxi[index].Fair.toStringAsFixed(2),myTaxi[index].Image);
                                    await fire.Addride(ThisUser.UID).then((value) => {

                                    CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.success,
                                    text: "Taxi Booked successfully!\nYour Ride will come in a while",
                                    ).then((value) {
                                      setState((){
                                        loading = false;
                                        didIbookTaxi = true;
                                        Navigator.of(context).pop();
                                      });
                                    }),
                                    });
                                  },
                                  child: Container(
                                    color: Colors.blue[900],
                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                    child: Text(
                                      "Order Taxi",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              (loading)?Align(
                alignment: Alignment.center,
                child: loading2(fromcolor: Colors.blue,
                    tocolor: Colors.red),
              )
                  :SizedBox(height: 0,),

            ],
          ),
        ],
      ),

    );
  }

}

