import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../dummys/dummy_data.dart';
import 'package:dreamers/models/dream.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class DreamsProvider with ChangeNotifier {
  String _token;
  List<Dream> dreamList = [];
  List<Dream> _dreams = DUMMY_DREAMS;
  final url = "http://192.168.0.7:8000/dreams/";

  //get dreams
  Future<void> get dreamsRemote async {

    final prefer = await SharedPreferences.getInstance();
    final extractedUserData =
        convert.jsonDecode(prefer.getString('userData')) as Map<String, Object>;
    print(extractedUserData);
    _token = extractedUserData['token'];
    dreamList = [];

    try {
      final response = await http.get(url, headers: {
        "Authorization": "token " + _token,
      });
      var responseList = convert.jsonDecode(response.body) as List<dynamic>;

      responseList.forEach((dreamData) {
        
        dreamList.add(Dream(
            id: dreamData['id'].toString(),
            description: dreamData['description'],
            title: dreamData['title'],
            imageUrl: dreamData['image'],
            isPublic: dreamData['is_public']));
      });

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }//get dreams

  List<Dream> get dreams {
    return [...dreamList];
  }

  Dream findById(String id) {
    return dreams.firstWhere((dream) => dream.id == id);
  }

  Future<void> addDream(Dream dream) {
    String token = "da60ba5215dacdb60bb290047df619eb951b151d";
    String dreamUrl = "http://192.168.0.10:8000/dreams/";
    const fireUrl =
        "https://dreamers-a4ada-default-rtdb.firebaseio.com/dreams.json";

    return http
        .post(fireUrl,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: convert.jsonEncode({
              "title": dream.title,
              "description": dream.description,
              "is_public": dream.isPublic,
              "user_account": 1,
              "image": dream.imageUrl
            }))
        .then((response) {
      print(response);
      _dreams.add(Dream(
          description: dream.description,
          id: DateTime.now().toString(),
          title: 'title'));
      notifyListeners();
    });
  }
}
