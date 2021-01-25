import 'package:dreamers/providers/auth_providers.dart';
import 'package:dreamers/screens/auth_screen.dart';
import 'package:dreamers/screens/dream_screen.dart';
import 'package:dreamers/screens/edit_dream_screen.dart';
import 'package:dreamers/screens/favorite_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          SizedBox(height: 5),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(
              'Home',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          SizedBox(height: 5),
          ListTile(
            leading: Icon(Icons.list),
            title: Text(
              'Dreams',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(DreamsScreen.routeName),
          ),
          SizedBox(height: 5),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(
              'Favorites',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(FavoriteScreen.routeName),
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(
              'Add Dream',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            onTap: () =>
                Navigator.of(context).pushNamed(EditDreamScreen.routeName),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}

/*

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

*/
