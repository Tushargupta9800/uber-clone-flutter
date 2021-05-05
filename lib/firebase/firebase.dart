import 'package:uberclone/main.dart';

class firebase{

  Future<void> Addride(String UID) async {

    print(UID);

    Map userDataMap = {
      "name": ThisUser.name,
      "email": ThisUser.email,
      "phone": ThisUser.Phone,
      "password": ThisUser.password,
      "last_from": presentRide.from_destination,
      "last_to": presentRide.to_destination,
      "last_fair": presentRide.fair,
      "Image": presentRide.Image,
    };
    await usersRef.child(UID).set(userDataMap);
  }

}