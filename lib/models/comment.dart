import 'package:flutter/material.dart';

class Comment {
  int commentId;
  int dreamId;
  int userId;
  String description;
  String username;
  String status;

  Comment(
      {this.commentId = 0,
      this.dreamId = 0,
      this.userId = 0,
      this.username = '',
      this.status = '',
      this.description = ''});
}
