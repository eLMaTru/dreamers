import 'package:flutter/material.dart';

class Comment {
  int commentId;
  int dreamId;
  int userId;
  String description;
  String username;
  String status;

  Comment({
     this.commentId, this.dreamId, this.userId, this.username, this.status, @required this.description
  });
}
