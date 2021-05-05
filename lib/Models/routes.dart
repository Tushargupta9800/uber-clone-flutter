class Routes{

  String encoded_string = "";
  double distance;
  String time;
  bool m = true;
  bool min = true;

  Routes({this.encoded_string,this.distance,this.time});

  void change_route(String encoded, double dis, int t){
    this.encoded_string = encoded;
    this.distance = dis;
    if(dis.toInt() > 1000){
      this.distance = this.distance/1000;
      m = false;
    }
    if(dis.toInt() < 1000){
      m = true;
    }

    Duration Totaltime = Duration(milliseconds: t);

      this.time = Totaltime.inMinutes.toString() + "." + Totaltime.inSeconds.remainder(60).toString();
      min = true;
      if(Totaltime.inMinutes > 60){
        min = false;
        this.time = Totaltime.inHours.toString() + "." + Totaltime.inMinutes.remainder(60).toString();
      }

    }
  }