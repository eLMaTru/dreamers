import 'package:flutter/material.dart';

class Dream {
  String id;
  String title;
  String description;
  String imageUrl;
  bool isPublic;
  bool isFavorite;
  bool isVoice;
  int commentLen;
  int likeLen;
  int dislikeLen;
  DateTime created;

  Dream(
      {this.id,
      this.title = '',
      @required this.description,
      this.imageUrl = '',
      this.isPublic = false,
      this.isVoice,
      this.isFavorite,
      this.commentLen,
      this.dislikeLen,
      this.likeLen,
      this.created});
}
