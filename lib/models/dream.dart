import 'package:flutter/material.dart';

class Dream {
  String id;
  String title;
  String description;
  String imageUrl;
  bool isPublic;

  Dream(
      {this.id, this.title = '', @required this.description, this.imageUrl = '', this.isPublic = false});
}
