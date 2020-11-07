import 'package:dreamers/dummys/dummy_data.dart';
import 'package:dreamers/widgets/drawer_item.dart';
import 'package:dreamers/widgets/dream_card.dart';
import 'package:flutter/material.dart';

import 'dream_detail_screen.dart';
import 'favorite_screen.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  String _mainText = "first text";

  void workingWithNavigation(BuildContext context) {
    Navigator.of(context).pushNamed(FavoriteScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final dreams = DUMMY_DREAMS.where((dream) => dream.isPublic).toList();

    return Scaffold(
      drawer: DrawerItem(),
      appBar: AppBar(
        title: Text('Dreamers'),
        centerTitle: true,
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return DreamCard(dreams[index]);
          },
          itemCount: dreams.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => workingWithNavigation(context),
      ),
    );
  }
}
