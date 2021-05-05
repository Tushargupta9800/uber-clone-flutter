import 'dart:convert';

import 'package:uberclone/APIs/maps.dart';
import 'package:http/http.dart' as http;
import 'package:uberclone/Secrets/key_secrets.dart';

import '../main.dart';

String Access_token = "";
String token_type = "";

Future<Map> get_my_token() async {
  suggestion_token = true;
  String url = "https://outpost.mapmyindia.com/api/security/oauth/token";

  Map<String, String> body = {
    "grant_type": "client_credentials",
    "client_id": "$OAuth2ClientId",
    "client_secret": "$OAuth2ClientSecret",
  };

  var response = await http.post(
    url,
    headers: <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: body,
    encoding: Encoding.getByName("utf-8"),
  );

  Map<dynamic, dynamic> res = await jsonDecode(response.body.toString());
  Access_token = res["access_token"];
  token_type = res["token_type"];
//print(res.toString());


}

Future<List<String>> Suggestions(String place) async {

  if(!suggestion_token) await get_my_token();
  String url = "https://atlas.mapmyindia.com/api/places/search/json?query="+place;
  var response = await http.get(url,
    headers: {'Authorization': token_type+" "+Access_token},
  );

    print(response.body);
  Map<dynamic, dynamic> res = await jsonDecode(response.body.toString());
//  print(res.toString());
  List<String> Suggestion = [];
  if(res["suggestedLocations"] != null){
    for(var i in res["suggestedLocations"]){
      Suggestion.add(i["placeName"] + ", " + i["placeAddress"]);
//    print(i.toString());
    }
  }

  return Suggestion;

}