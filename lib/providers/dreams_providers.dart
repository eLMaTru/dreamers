import 'package:shared_preferences/shared_preferences.dart';

import '../dummys/dummy_data.dart';
import 'package:dreamers/models/dream.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class DreamsProvider with ChangeNotifier {
  String _token;
  String _userId;
  String _userName;
  List<Dream> dreamList = [];
  List<Dream> _dreams = DUMMY_DREAMS;

  String baseUrl = 'http://192.168.0.5:8000/';

  Future<void> getPreferencesInfo() async {
    final prefer = await SharedPreferences.getInstance();
    final extractedUserData =
        convert.jsonDecode(prefer.getString('userData')) as Map<String, Object>;
    print(extractedUserData);
    _userId = extractedUserData["userId"];
    _token = extractedUserData['token'];
    _userName = extractedUserData['username'];
  }

  //get dreams
  Future<void> get dreamsRemote async {
    this.getPreferencesInfo().then((res) async {
      final url = baseUrl + "dreams/status/?status=enabled&isPublic=True";

      dreamList = [];

      try {
        final response = await http.get(url, headers: {
          "Authorization": "token " + _token,
        });
        var responseList = convert.jsonDecode(response.body) as List<dynamic>;

        responseList.forEach((dreamData) {
          String username = dreamData['user_account']['user']['username'];
          int userId = dreamData['user_account']['id'];
          String date =
              dreamData['created_at'].substring(0, 16).replaceAll('T', " ");
          dreamList.add(Dream(
              id: dreamData['id'].toString(),
              description: dreamData['description'],
              title: dreamData['title'],
              imageUrl: dreamData['image'],
              isPublic: dreamData['is_public'],
              commentLen: dreamData['comment_len'],
              dislikeLen: dreamData['dislike_len'],
              likeLen: dreamData['like_len'],
              isVoice: dreamData['is_voice'],
              username: username,
              userId: userId,
              userImage: dreamData['user_account']['image_url'],
              created: date));
        });

        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    });
  } //get dreams

  List<Dream> get dreams {
    return [...dreamList];
  }

  Dream findById(String id) {
    return dreams.firstWhere((dream) => dream.id == id);
  }

  Future<void> addDream(Dream dream) async {
    final url = baseUrl + "dreams/";

    return http
        .post(url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "token " + _token,
            },
            body: convert.jsonEncode({
              "title": dream.title,
              "description": dream.description,
              "is_public": dream.isPublic,
              "user_account": _userId,
              "image": dream.imageUrl
            }))
        .then((response) {
      print(response);
      var dreamData = convert.jsonDecode(response.body) as Map<String, Object>;
      String date = dreamData['created_at'];
      date = date.substring(0, 16).replaceAll('T', " ");
      _dreams.add(Dream(
          description: dream.description,
          commentLen: dreamData['comment_len'],
          dislikeLen: dreamData['dislike_len'],
          likeLen: dreamData['like_len'],
          isVoice: dreamData['is_voice'],
          imageUrl: dreamData['image'],
          id: dreamData['id'],
          userId: dreamData['user_account'],
          title: dream.title,
          created: date));
      notifyListeners();
    });
  }

  Future<Map<String, Object>> addReaction(dream, isLike) async {
    final url = baseUrl + "reactions/sets/";
    print(this._userId);
    bool can = true;

    return http
        .post(url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "token " + _token,
            },
            body: convert.jsonEncode({
              "isLike": isLike,
              "userName": _userName,
              "dreamId": dream.id,
              "userId": _userId, 
            }))
        .then((response) {
         var reactionData = convert.jsonDecode(response.body) as Map<String, Object>; 
      print(reactionData);
      return Future.value(reactionData);
    });
  }
}
