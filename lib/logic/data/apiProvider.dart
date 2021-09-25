import 'dart:convert';

import 'package:evoter/models/sessionConstants.dart';
import 'package:evoter/models/sharedObjects.dart';
import 'package:evoter/models/user.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  Future<bool> login(String mobileNo, String password) async {
    String baseUrl = "http://www.anugat.com/api/voterLogin";
    final Uri baseUri = Uri.parse(baseUrl);
    final response = await http.post(baseUri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, dynamic>{"MobileNo": mobileNo, "Password": password}));
   
    await SharedObjects.prefs
        ?.setString(SessionConstants.sessionUid, response.body.split('"')[1]);
    return response.statusCode == 200;
  }

  Future<bool> addUser(CurrentUser user) async {
    String baseUrl = "http://www.anugat.com/api/NewUser";
    final Uri baseUri = Uri.parse(baseUrl);
    final response = await http.post(baseUri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toMap()));
    return response.statusCode == 200;
  }

  Future<bool> updateUser(CurrentUser user) async {
    String baseUrl = "http://www.anugat.com/api/UpdateUser";
    final Uri baseUri = Uri.parse(baseUrl);
    final response = await http.post(baseUri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toMap()));
    return response.statusCode == 200;
  }

  Future<bool> deleteUser(String userCode) async {
    String baseUrl = "http://www.anugat.com/api/DeleteUser";
    final Uri baseUri = Uri.parse(baseUrl);
    final response = await http.post(baseUri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{"Code": userCode}));
    return response.statusCode == 200;
  }

  Future<dynamic> fetchAllUsers() async {
    String baseUrl = "http://www.anugat.com/api/FetchAllUsers?AddedBy=${SharedObjects.prefs?.getString(SessionConstants.sessionUid)}";
    final Uri baseUri = Uri.parse(baseUrl);
    final response = await http.get(baseUri);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return CurrentUser.fromJson(response.body);
    } else {
      throw Exception("Failed to load user");
    }
  }
}
