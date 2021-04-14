import 'package:flutter/cupertino.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;

  String baseUrl = 'http://192.168.0.7:8000/';

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    return _token;
  }

  Future<void> signup(String email, username, password) async {
    var signupUrl = Uri.parse(baseUrl + "users/create/");
    try {
      final response = await http.post(
        signupUrl,
        body: convert.jsonEncode(
            {'email': email, 'password': password, 'username': username}),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
      );
      final data = convert.jsonDecode(response.body);

      _token = data['token'];
      _userId = data['user_account_id'];

      notifyListeners();
      final prefer = await SharedPreferences.getInstance();
      final userData = convert.jsonEncode({
        'token': _token,
        'username': username,
        'password': password,
        "userId": data['user_account_id']
      });
      prefer.setString('userData', userData);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> login(String username, String password) async {
    var loginUrl = Uri.parse(baseUrl + "login/");

    try {
      final response = await http.post(
        loginUrl,
        body: convert.jsonEncode({"username": username, "password": password}),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
      );

      final data = convert.jsonDecode(response.body) as Map<String, Object>;
      var errorMessage;
      if (data['__all__'] != null) {
        throw errorMessage = data['__all__'];
      }
      _token = data['token'];
      _userId = data['user_account_id'];
      notifyListeners();
      final prefer = await SharedPreferences.getInstance();
      final userData = convert.jsonEncode({
        'token': _token,
        'username': username,
        'password': password,
        "userId": data['user_account_id']
      });
      prefer.setString('userData', userData);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefer = await SharedPreferences.getInstance();
    if (!prefer.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        convert.jsonDecode(prefer.getString('userData')) as Map<String, Object>;
    print(extractedUserData);
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    notifyListeners();
    final prefer = await SharedPreferences.getInstance();
    prefer.remove('userData');
  }
}
