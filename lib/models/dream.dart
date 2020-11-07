import 'package:flutter/material.dart';

class Dream {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final bool isPublic;

  const Dream(
      {@required this.id,
      @required this.title,
      @required this.description, this.imageUrl,
      this.isPublic = false});
}
