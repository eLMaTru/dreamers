import 'package:dreamers/models/comment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dummys/dummy_data.dart';
import 'package:dreamers/models/dream.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class DreamsProvider with ChangeNotifier {
  bool isLoading = true;
  String _token;
  String _userId;
  String _userName;
  List<Dream> dreamList = [];
  List<Dream> _ownDreams = [];
  List<dynamic> _ownDreamsTMP = [];
  List<Dream> _dreams = DUMMY_DREAMS;
  List<Comment> _comments = [];

  String baseUrl = 'http://192.168.0.7:8000/';

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
      var url = Uri.parse(
        baseUrl + "dreams/status/?status=enabled&isPublic=True",
      );
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

  List<Dream> get ownDreams {
    return [..._ownDreams];
  }

  Dream findOwnDreamById(String id) {
    return ownDreams.firstWhere((dream) => dream.id == id);
  }

  Dream findById(String id) {
    return dreams.firstWhere((dream) => dream.id == id);
  }

  Future<void> addDream(Dream dream) async {
    final url = Uri.parse(baseUrl + "dreams/");

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
          id: dreamData['id'].toString(),
          userId: dreamData['user_account'],
          title: dream.title,
          created: date));
      notifyListeners();
    });
  }

  List get ownDreamsTMP => [..._ownDreamsTMP];

  Future<List> getOwnDreams() async {
    if (_ownDreamsTMP != null && _ownDreamsTMP.length > 0) {
      return _ownDreamsTMP;
    }
    final url =
        Uri.parse(baseUrl + "dreams/?status=enabled&user_account=${_userId}");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "token " + _token,
      },
    );

    _ownDreamsTMP = convert.jsonDecode(response.body) as List<dynamic>;
    _ownDreamsTMP.forEach((dreamData) {
      int userId = dreamData['user_account'];
      String date =
          dreamData['created_at'].substring(0, 16).replaceAll('T', " ");
      _ownDreams.add(Dream(
          id: dreamData['id'].toString(),
          description: dreamData['description'],
          title: dreamData['title'],
          imageUrl: dreamData['image'],
          isPublic: dreamData['is_public'],
          commentLen: dreamData['comment_len'],
          dislikeLen: dreamData['dislike_len'],
          likeLen: dreamData['like_len'],
          isVoice: dreamData['is_voice'],
          username: _userName,
          userId: userId,
          created: date));
    });

    notifyListeners();
  }

  Future<void> editDream(Dream dream) async {
    final url = Uri.parse(baseUrl + "dreams/${dream.id}/");

    if (dream.userId == int.parse(_userId) && _ownDreams.length > 0) {
      int index = _ownDreams.indexWhere((Dream d) => d.id == dream.id);
      _ownDreams.removeAt(index);
      _ownDreams.insert(index, dream);
    }
    return http
        .put(url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "token " + _token,
            },
            body: convert.jsonEncode({
              "id": dream.id,
              "title": dream.title,
              "description": dream.description,
              "is_public": dream.isPublic,
              "user_account": _userId,
              "image": dream.imageUrl,
              "comment_len": dream.commentLen
            }))
        .then((response) {
      print(response);
      var dreamData = convert.jsonDecode(response.body) as Map<String, Object>;

      notifyListeners();
    });
  }

  Future<void> deleteDream(Dream dream) async {
    try {
      int index = _ownDreams.indexWhere((Dream d) => d.id == dream.id);
      _ownDreams.removeAt(index);
      final url = Uri.parse(baseUrl + "dreams/${dream.id}/");

      final response = await http.put(url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "token " + _token,
          },
          body: convert.jsonEncode({
            "id": dream.id,
            "title": dream.title,
            "description": dream.description,
            "is_public": dream.isPublic,
            "user_account": _userId,
            "image": dream.imageUrl,
            "status": 'delete'
          }));
    } catch (error) {
      print(error);
    }
  }
//                          Dreams
//--------------------------------------

//                          COMMENT
//
  List<Comment> get commnets {
    return [..._comments];
  }

  Future<void> addComment(String dreamId, String comment) async {
    try {
      final url = Uri.parse(baseUrl + "comments/");
      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "token " + _token,
          },
          body: convert.jsonEncode({
            "description": comment,
            "username": _userName,
            "dream": dreamId,
            "user_account": _userId
          }));

      var com = convert.jsonDecode(response.body) as Map<String, Object>;
      _comments.add(Comment(
          description: com['description'],
          commentId: com['id'],
          dreamId: com['dream'],
          status: com['status'],
          userId: com['user_account'],
          username: com['username']));

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchComments(Dream dream) async {
    try {
      if (_comments != null &&
          _comments.length > 0 &&
          _comments[0].dreamId == int.parse(dream.id)) {
        return _comments;
      }
      final url =
          Uri.parse(baseUrl + "comments/?status=enabled&dream=${dream.id}");
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "token " + _token,
      });
      var commentData = convert.jsonDecode(response.body) as List<dynamic>;
      if (commentData == null) {
        return;
      }
      _comments = [];
      commentData.forEach((com) {
        _comments.add(Comment(
            description: com['description'],
            commentId: com['id'],
            dreamId: com['dream'],
            status: com['status'],
            userId: com['user_account'],
            username: com['username']));
      });

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  void clearComments() {
    _comments = [];
  }

  Future<int> deleteComment(Comment com) async {
    try {
      int index =
          _comments.indexWhere((Comment c) => c.commentId == com.commentId);
      _comments.removeAt(index);

      final url = Uri.parse(baseUrl + "comments/${com.commentId}/");
      final response = await http.put(url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "token " + _token,
          },
          body: convert.jsonEncode({
            "description": com.description,
            "username": _userName,
            "dream": com.dreamId,
            "user_account": _userId,
            "status": "delete"
          }));

      var data = convert.jsonDecode(response.body) as Map<String, Object>;

      notifyListeners();
      return index;
    } catch (error) {}
  }

  void sumAndSustractCommentQ(String dreamId, bool isPlus) {
    try {
      Dream dream;
      this._dreams.firstWhere((Dream d) {
        if (d.id == dreamId) {
          if (!isPlus && d.commentLen > 0) {
            d.commentLen -= 1;
          } else {
            d.commentLen += 1;
          }
          dream = d;
        }
        return;
      });

      this._ownDreams.firstWhere((Dream dream) {
        if (dream.id == dreamId) {
          if (!isPlus && dream.commentLen > 0) {
            dream.commentLen -= 1;
          } else {
            dream.commentLen += 1;
          }
        }
        return;
      });

      this.editDream(dream);
    } catch (error) {
      print(error);
    }
  }

  //                          COMMENT
//
//
//
//-------------------------------------------------------------

// Reactions
//
//
//

  Future<Map<String, Object>> addReaction(dream, isLike) async {
    final url = Uri.parse(baseUrl + "reactions/sets/");
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
      var reactionData =
          convert.jsonDecode(response.body) as Map<String, Object>;
      print(reactionData);
      return Future.value(reactionData);
    });
  }
}
