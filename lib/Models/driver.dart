class driver{

  String name;
  String driverID;
  double rating;
  int PhoneNumber;

  driver({this.name,this.driverID,this.rating,this.PhoneNumber});

  void update_driver(String name, String ID,double rate, int number){
    this.name  = name;
    this.driverID = ID;
    this.rating = rate;
    this.PhoneNumber = PhoneNumber;
  }

}