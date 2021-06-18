import 'package:dreamers/screens/auth_screen.dart';
import 'package:dreamers/screens/dream_screen.dart';
import 'package:dreamers/screens/favorite_screen.dart';
import 'package:dreamers/screens/splash_screen.dart';


import 'providers/auth_providers.dart';
import 'screens/dream_detail_screen.dart';
import 'screens/edit_dream_screen.dart';
import 'screens/home_screen.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './providers/dreams_providers.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*FirebaseAdMob.instance
      .initialize(appId: 'ca-app-pub-7751802787814761~8452429840');
  final FirebaseApp app =  await Firebase.initializeApp(
    name: "dreamers",
    options: FirebaseOptions(
      appId: '',
      apiKey: 'AIzaSyBwJwerO__Jk51-87Up5ZAGP0t5SDlzzfg',
      messagingSenderId: '',
      projectId: 'dreamers-a4ada',
      databaseURL: 'https://dreamers-a4ada-default-rtdb.firebaseio.com',
    ),
  );*/
  runApp(DreamersApp());
 
 
}

class DreamersApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final Brightness brightnessValue =        MediaQuery.of(context).platformBrightness;
    bool isDark = false; //brightnessValue == Brightness.dark;
    final themeData = isDark
        ? ThemeData(brightness: Brightness.dark, accentColor: Colors.indigo)
        : ThemeData(
            accentColor: Colors.indigo,
            brightness: Brightness.light,
            primaryColor: Colors.white);

    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: DreamsProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => AuthProvider(),
          ),
        ],
        child: Consumer<AuthProvider>(
          builder: (context, authData, _) => MaterialApp(
            theme: themeData,
            debugShowCheckedModeBanner: true,
            home:
                authData.isAuth
                ? HomePage()
                : FutureBuilder(future: authData.tryAutoLogin(), builder: (context, authResultSnapshot,) {
               if (authResultSnapshot.connectionState == ConnectionState.waiting) {
                 return SplashScreen();
               } else {
                 return AuthScreen();
               }})
            ,
            onGenerateRoute: (settings) {
              //print(settings.arguments);
              return MaterialPageRoute(builder: (context) => HomePage());
            },
            onUnknownRoute: (settings) {
              return MaterialPageRoute(builder: (context) => HomePage());
            },
            routes: {
              HomePage.routeName: (_) => HomePage(),
              DreamDetailScreen.routeName: (context) => DreamDetailScreen(),
              FavoriteScreen.routeName: (context) => FavoriteScreen(),
              DreamsScreen.routeName: (context) => DreamsScreen(),
              EditDreamScreen.routeName: (context) => EditDreamScreen(),
              AuthScreen.routeName: (context) => AuthScreen(),
              SplashScreen.routeName: (context) => SplashScreen()
            },
          ),
        ));
  }

  Map<String, WidgetBuilder> get newMethod {
    return {
      //'/': (_) => HomePage(),
      DreamDetailScreen.routeName: (context) => DreamDetailScreen(),
      FavoriteScreen.routeName: (context) => FavoriteScreen(),
      DreamsScreen.routeName: (context) => DreamsScreen(),
      EditDreamScreen.routeName: (context) => EditDreamScreen(),
      AuthScreen.routeName: (context) => AuthScreen(),
      SplashScreen.routeName: (context) => SplashScreen()
    };
  }
}

