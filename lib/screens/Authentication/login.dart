import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uberclone/main.dart';
import '../Widgets/loading.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

String Email, Password;
bool showloading = false;
bool saved = false;

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (showloading)?Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: loading2(fromcolor: Colors.yellowAccent,
              tocolor: Colors.redAccent),
        ),
      ):SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.0,),
              Hero(
                  tag: "Auth",
                  child: Image.asset("assets/images/logo1.png",scale: 3,)),
              Text(
                "Login as a rider",
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: "Brand Bold",
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width-40,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val){
                    Email = val;
                  },
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: "Brand Bold"
                  ),
                  decoration: InputDecoration(
                    hintText: "E-Mail",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Brand Bold",
                    ),
                  ),
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width-40,
                child: TextFormField(
                  obscureText: true,
                  onChanged: (val){
                    Password = val;
                  },
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: "Brand Bold",
                  ),
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Brand Bold",
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.0,),

              GestureDetector(
                onTap: () async{
                    setState(() {
                      showloading = true;
                    });

                    try {
                      final User firebaseuser = (
                          await _auth.signInWithEmailAndPassword(
                          email: Email, password: Password)
                  ).user;

                  if(firebaseuser != null){
                      await usersRef.child(firebaseuser.uid).once().then((DataSnapshot snap) async {
                      if(snap.value != null){
                        print(snap.value);
                        tsnap = snap.value;
                        await lastRide.add_rides(snap.value["last_from"],snap.value["last_to"], snap.value["last_fair"],snap.value["Image"]);
                        await ThisUser.form_user(snap.value["name"], snap.value["email"], snap.value["phone"],firebaseuser.uid.toString(),snap.value["password"]).then((value) {
                          setState(() {});
                          displytoast("Congratulations, Now you are no board").then((value) {
                            setState(() {
                              print("name");
                              print(ThisUser.name);
                              print("getting namelogin");
                                // Navigator.of(context).pop();
                                Navigator.pushNamed(context, "/homescreen");
                            });
                          });
                        });
                      }
                  else{
                      displytoast("Error In login User");
                  }
                      });
                  }
                  else{
                      displytoast("Error In Signed In");
                  }

                  }catch(e){
                  print(e.toString());
                  displytoast(e.toString().split(']')[1]);
                  }

                  setState(() {
                    showloading = false;
                  });


//                    AuthenticateUser(context).then((value) => setState((){
//                      showloading = false;
//                    }));
                },

                child: Container(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: Colors.yellow,
                  ),
                  child: Center(
                    child: Text("Sign In",style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: "Brand Bold",
                    ),),
                  ),
                ),
              ),

              SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text("Don't have an account? ",style: TextStyle(
                      fontFamily: "Brand Bold",
                    ),),
                  GestureDetector(

                    onTap: (){
                      Navigator.pushNamedAndRemoveUntil(context, "/register", (route) => false);
                    },

                    child: Text("Register Here", style: TextStyle(
                      color: Colors.blue,
                      fontFamily: "Brand Bold",
                    ),),
                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}

final FirebaseAuth _auth = FirebaseAuth.instance;


// Future<void> AuthenticateUser(BuildContext context) async {
//
//   try {
//     final User firebaseuser = (
//         await _auth.signInWithEmailAndPassword(
//             email: Email, password: Password)
//     ).user;
//
//     if(firebaseuser != null){
//       await usersRef.child(firebaseuser.uid).once().then((DataSnapshot snap){
//         if(snap.value != null){
//           print(snap.value);
//           tsnap = snap.value;
//           lastRide.add_rides(snap.value["last_from"],snap.value["last_to"], snap.value["last_fair"],snap.value["Image"]);
//           ThisUser.form_user(snap.value["name"], snap.value["email"], snap.value["phone"],firebaseuser.uid.toString(),snap.value["password"]);
//           displytoast("Congratulations, Now you are no board");
//           Navigator.pushNamedAndRemoveUntil(context, "/homescreen", (route) => false);
//         }
//         else{
//           displytoast("Error In login User");
//         }
//       });
//     }
//     else{
//       displytoast("Error In Signed In");
//     }
//
//   }catch(e){
//     print(e.toString());
// //    displytoast(e.toString().split(']')[1]);
//   }
//
// }

Future<void> displytoast(String msg) => Fluttertoast.showToast(msg: msg,toastLength: Toast.LENGTH_SHORT);
