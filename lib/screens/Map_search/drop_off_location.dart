import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uberclone/APIs/maps.dart';
import 'package:uberclone/APIs/suggestions.dart';
import 'package:uberclone/main.dart';
import 'package:uberclone/screens/Widgets/decoration.dart';
import 'package:uberclone/screens/Widgets/loading.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class Drop_Off_Location extends StatefulWidget {
  @override
  _Drop_Off_LocationState createState() => _Drop_Off_LocationState();
}

class _Drop_Off_LocationState extends State<Drop_Off_Location> {

  bool showloading = false;
  List<String> mySuggestion = [];
  int count = 10;
  var fromLocationController = new TextEditingController();
  var toLocationController = new TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> key1 = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> key2 = new GlobalKey();

  @override
  void initState() {
    print("dropoffname:::");
    print(ThisUser.name);
    mySuggestion.add("India");
    mySuggestion.add("Delhi");
    fromLocationController.text = from_location.address;
    toLocationController.text = (to_location.address == "" || to_location.address == null)?"Rashtrapati Bhawan, President's Estate, New Delhi, Delhi 110004":to_location.address;
    fromLocationController.addListener(() {
      if(fromLocationController.text[fromLocationController.text.length - 1] == " "){
        Suggestions(fromLocationController.text).then((value) async {
          await mySuggestion.clear();
          mySuggestion.addAll(value);
          setState(() {});
        });
      }
      setState(() {});
    });
    toLocationController.addListener(() {
      if(toLocationController.text[toLocationController.text.length - 1] == " "){
        Suggestions(toLocationController.text).then((value) async {
          await mySuggestion.clear();
          mySuggestion.addAll(value);
          setState(() {});
        });
      }
      setState(() {});
    });
    super.initState();
  }

  Widget row(String name) {
    print("I'm Here");
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 10.0),
          width: MediaQuery.of(context).size.width - 155,
          child: Text(
            name,
            style: TextStyle(color: Colors.black54,fontSize: 14.0),
            overflow: TextOverflow.fade,),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 2.5;
    AutoCompleteTextField<String> tolocationauto;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Where to Drop you?",
        ),
      ),
      body: (showloading)?Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: loading2(fromcolor: Colors.yellowAccent,
              tocolor: Colors.redAccent),
        ),
      ):Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              left: 25.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  space(15.0),
                  Text("Pick Up Location:-", style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),),
                  space(15.0),
                  Container(
                    width: MediaQuery.of(context).size.width - 50,
                    decoration: box_decoration(),
                    child: Row(
                      children: [
                        side_space(10.0),
                        Hero(
                          tag: "image",
                            child: Icon(Icons.home)),
                        side_space(10.0),
                        Container(
                          width: MediaQuery.of(context).size.width - 145,
                          child: AutoCompleteTextField<String>(
                            key: key1,
                            clearOnSubmit: false,
                            suggestions: mySuggestion,
                            controller: fromLocationController,
                            itemSubmitted: (item) {
                                    print(item);
                            },
                            itemFilter: (item, query) {
                              return item.toLowerCase().isNotEmpty;
                            },
                            itemSorter: (a, b) {
                              return a.compareTo(b);
                            },
                            itemBuilder: (context, item) {
                              return row(item);
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () => fromLocationController.clear(),
                          icon: Icon(Icons.clear),
                        ),
                      ],
                    ),
                  ),

                  space(15.0),
                  Text("Drop off Location:-", style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),),
                  space(15.0),
                  Container(
                    width: MediaQuery.of(context).size.width - 50,
                    decoration: box_decoration(),
                    child: Row(
                      children: [
                        side_space(10.0),
                        Hero(
                            tag: "secondImage",
                            child: Icon(Icons.work)),
                        side_space(10.0),
                        Container(
                          width: MediaQuery.of(context).size.width - 145,
                          child: AutoCompleteTextField<String>(
                            key: key2,
                            clearOnSubmit: false,
                            suggestions: mySuggestion,
                            controller: toLocationController,
                            itemSubmitted: (item) {
                              print(item);
                            },
                            itemFilter: (item, query) {
                              return item.toLowerCase().isNotEmpty;
                            },
                            itemSorter: (a, b) {
                              return a.compareTo(b);
                            },
                            itemBuilder: (context, item) {
                              return row(item);
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () => toLocationController.clear(),
                          icon: Icon(Icons.clear),
                        ),
                      ],
                    ),
                  ),

                  space(30.0),

                  GestureDetector(

                    onTap: () async {
                      setState(() {
                        showloading = true;
                      });
                      if(checktext()) {
                        await mycoordinates(fromLocationController.text).then((
                            value) {
                          from_location.change_address(
                              fromLocationController.text, value);
                          mycoordinates(toLocationController.text).then((
                              value) {
                            to_location.change_address(
                                toLocationController.text, value);
                            setState(() {
                              showloading = false;
                              Navigator.of(context).pop("changed");
                            });
                          });
                        });
                      }

                      setState(() {
                        showloading = false;
                      });

                    },
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: round_decoration(15.0),
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool checktext(){
    if(fromLocationController.text.isEmpty || toLocationController.text.isEmpty){
      Fluttertoast.showToast(msg: "Invalid origin location or destination", toastLength: Toast.LENGTH_LONG);
      return false;
    }
    return true;
  }

}
