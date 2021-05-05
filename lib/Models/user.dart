class rides{

  String from_destination = "";
  String to_destination;
  String fair;
  String Image;

  rides({this.from_destination,this.to_destination,this.fair,this.Image});

  add_rides(String from, String to, String m,String Image){
    this.from_destination = from;
    this.to_destination = to;
    this.fair = m;
    this.Image = Image;
  }

  Map<String,dynamic> toMap(){
    return {
    "from_destination": this.from_destination,
    "to_destination": this.to_destination,
    "fair": this.fair,
    };
  }

}


class user{

  String name = "";
  String email = "";
  String Phone = "";
  String UID = "";
  String password = "";

  user({this.name,this.email,this.Phone,this.UID,this.password});

  Future<void> form_user(String name, String email, String Phone,String uid,String password)async{

    print("inuser::");
    print(name);

    this.name = name;
    this.email = email;
    this.Phone = Phone;
    this.password = password;
    this.UID = uid;

    print("userSaved name:::");
    print(this.name);

    await Future.delayed(const Duration(microseconds: 1), () => this.name);

  }

  get_name(){
    print(this.name);
  }

  get_mail(){
    return this.email;
  }



}