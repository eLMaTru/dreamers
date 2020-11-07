import 'package:dreamers/widgets/drawer_item.dart';
import 'package:flutter/material.dart';

class DreamsScreen extends StatelessWidget {
  static const String routeName = "/dreams";

  @override
  Widget build(BuildContext context) {
    return Scaffold(drawer: DrawerItem(),
    appBar: AppBar(title: Text('Dreams'),),
      body: Container( child:Center(child: Text('favorites'),),
    ),
    );
  }
}
