import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uberclone/main.dart';

import '../Widgets/loading.dart';

String Email, Password;
String Number,name;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool showloading = false;

  @override
  Widget build(BuildContext context) {
    timeDilation = 2;
    return Scaffold(
      body: (showloading)?loading2(fromcolor: Colors.yellowAccent,
          tocolor: Colors.redAccent):SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.0,),
              Hero(
                  tag: "Auth",
                  child: Image.asset("assets/images/logo1.png",scale: 3,)),
              Text(
                "Signup as a rider",
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: "Brand Bold",
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width-40,
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  onChanged: (val){
                    name = val;
                  },
                  style: TextStyle(
                      fontSize: 15.0,
                      fontFamily: "Brand Bold"
                  ),
                  decoration: InputDecoration(
                    hintText: "Username",
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
                  keyboardType: TextInputType.phone,
                  onChanged: (val){
                    Number = val;
                  },
                  style: TextStyle(
                      fontSize: 15.0,
                      fontFamily: "Brand Bold"
                  ),
                  decoration: InputDecoration(
                    hintText: "Phone Number",
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
                    hintText: "Create Password",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Brand Bold",
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.0,),

              GestureDetector(
                onTap: (){

                    if(name.length < 5 || Password.length < 5){
                      displytoast("Please Enter a valid username or password");
                    }
                    else if(Number.length < 10 || Number.length > 13){
                      displytoast("Please Enter a Valid Phone Number");
                    }
                    else if(!Email.contains('@')){
                      displytoast("Please Enter a valid Email address");
                    }
                    else{
                      setState(() {
                        showloading = true;
                      });
                      registerUser(context).then((value) => setState((){
                        showloading = false;
                      }));
                    }
                },

                child: Container(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: Colors.yellow,
                  ),
                  child: Center(
                    child: Text("Register",style: TextStyle(
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
                  Text("Already have an account? ",style: TextStyle(
                    fontFamily: "Brand Bold",
                  ),),
                  GestureDetector(

                    onTap: (){
                      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
                    },

                    child: Text("Sign In Here", style: TextStyle(
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

Future<void> registerUser(BuildContext context) async {

  try {
    final User firebaseuser = (
        await _auth.createUserWithEmailAndPassword(
            email: Email.trim(), password: Password.trim())
    ).user;

    if(firebaseuser != null){
      usersRef.child(firebaseuser.uid);
      Map userDataMap = {

        "name": name.trim(),
        "email": Email.trim(),
        "phone": Number.trim(),
        "password": Password.trim(),
        "rides": [],
      };

      ThisUser.form_user(name.trim(), Email.trim(), Number.trim(), firebaseuser.uid, Password.trim());

      await usersRef.child(firebaseuser.uid).set(userDataMap);
      displytoast("Congratulations, Now you are no board");

      Navigator.pushNamedAndRemoveUntil(context, "/homescreen", (route) => false);

    }
    else{
      displytoast("Error In registering User");
    }

  }catch(e){
    displytoast(e.toString().split(']')[1]);
  }

}

displytoast(String msg) => Fluttertoast.showToast(msg: msg);