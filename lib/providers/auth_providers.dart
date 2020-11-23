import 'package:flutter/cupertino.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;

  Future<void> signup(String email, username, password) async {
    String url = "http://192.168.0.10:8000/users/create/";
    try {
      final response = await http.post(url,
          body: convert.jsonEncode(
              {'username': username, 'email': email, 'password': password}), headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },);
      print(convert.jsonDecode(response.body));
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
