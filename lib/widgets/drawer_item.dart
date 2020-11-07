import 'package:dreamers/screens/dream_screen.dart';
import 'package:dreamers/screens/favorite_screen.dart';
import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
            child: Container(
              color: Theme.of(context).primaryColor,
              height: 100,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(20),
              child: Text(
                'Menu',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 10),
          ListTile(
              leading: Icon(Icons.list),
              title: Text(
                'Dreams',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              onTap: () =>
                  Navigator.of(context).pushReplacementNamed(DreamsScreen.routeName),),
          SizedBox(height: 10),
          ListTile(
              leading: Icon(Icons.favorite),
              title: Text(
                'Favorites',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              onTap: () =>
                  Navigator.of(context).pushReplacementNamed(FavoriteScreen.routeName),),
        ],
      ),
    );
  }
}
