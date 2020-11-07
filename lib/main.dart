import 'package:dreamers/screens/dream_screen.dart';
import 'package:dreamers/screens/favorite_screen.dart';

import 'screens/dream_detail_screen.dart';
import 'screens/home_screen.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(DreamersApp());
}

class DreamersApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(accentColor: Colors.green, primaryColor: Colors.indigo),
      debugShowCheckedModeBanner: true,
      //home: HomePage(),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        print(settings.arguments);
        return MaterialPageRoute(builder: (context) => HomePage());
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => HomePage());
      },
      routes: {
        '/': (_) => HomePage(),
        DreamDetailScreen.routeName: (context) => DreamDetailScreen(),
        FavoriteScreen.routeName: (context) => FavoriteScreen(),
        DreamsScreen.routeName: (context) => DreamsScreen(),
      },
    );
  }
}
