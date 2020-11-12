import 'package:dreamers/screens/dream_screen.dart';
import 'package:dreamers/screens/favorite_screen.dart';

import 'screens/dream_detail_screen.dart';
import 'screens/edit_dream_screen.dart';
import 'screens/home_screen.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './providers/dreams_providers.dart';

void main() {
  runApp(DreamersApp());
}

class DreamersApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final Brightness brightnessValue =        MediaQuery.of(context).platformBrightness;
    bool isDark = false; //brightnessValue == Brightness.dark;
    final themeData = isDark
        ? ThemeData(brightness: Brightness.dark, accentColor: Colors.indigo)
        : ThemeData(accentColor: Colors.indigo, brightness: Brightness.light, primaryColor: Colors.white);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => DreamsProvider(),
        ),
      ],
      child: MaterialApp(
        theme: themeData,

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
          EditDreamScreen.routeName: (context) => EditDreamScreen(),
        },
      ),
    );
  }
}
