import '../dummys/dummy_data.dart';
import 'package:dreamers/models/dream.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class DreamsProvider with ChangeNotifier {
  final url = "http://192.168.0.10:8000/dreams/";

  Future<List<Dream>> get dreamsRemote async {
    try {
      final response = await http.get(url, headers: {
        "Authorization": "Token da60ba5215dacdb60bb290047df619eb951b151d"
      });
      var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
      final List<Dream> tmpList = [];
      jsonResponse.forEach((dreamData) {
        print(dreamData);
      });
     
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  List<Dream> _dreams = DUMMY_DREAMS;

  List<Dream> get dreams {
    //this.dreamsRemote;
    return [..._dreams];
  }

  Dream findById(String id) {
    return dreams.firstWhere((dream) => dream.id == id);
  }

  Future<void> addDream(Dream dream) {
    String token = "da60ba5215dacdb60bb290047df619eb951b151d";
    String dreamUrl = "http://192.168.0.10:8000/dreams/";

    return http
        .post(dreamUrl,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: convert.jsonEncode({
              "name": dream.title,
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
