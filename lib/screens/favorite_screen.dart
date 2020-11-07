
import 'package:dreamers/widgets/drawer_item.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  static const routeName = "/favorites";

  @override
  Widget build(BuildContext context) {
    return Scaffold(drawer: DrawerItem(),
    appBar: AppBar(title: Text('Favorites'),),
      body: Container( child:Center(child: Text('favorites'),),
    ),
    );
  }
}