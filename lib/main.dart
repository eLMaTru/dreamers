import 'package:dreamers/screens/auth_screen.dart';
import 'package:dreamers/screens/dream_screen.dart';
import 'package:dreamers/screens/favorite_screen.dart';
import 'package:dreamers/screens/splash_screen.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'providers/auth_providers.dart';
import 'screens/dream_detail_screen.dart';
import 'screens/edit_dream_screen.dart';
import 'screens/home_screen.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './providers/dreams_providers.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

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
  myBanner
    ..load()
    ..show(
      // Positions the banner ad 60 pixels from the bottom of the screen
      anchorOffset: 0.0,
      // Positions the banner ad 10 pixels from the center of the screen to the right
      horizontalCenterOffset: 0.0,
      // Banner Position
      anchorType: AnchorType.bottom,
    );
  /* myInterstitial
    ..load()
    ..show(
      anchorType: AnchorType.bottom,
      anchorOffset: 0.0,
      horizontalCenterOffset: 0.0,
    );*/
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
                : AuthScreen() /*FutureBuilder(future: authData.tryAutoLogin(), builder: (context, authResultSnapshot,) {
               if (authResultSnapshot.connectionState == ConnectionState.waiting) {
                 return SplashScreen();
               } else {
                 return AuthScreen();
               }})*/
            ,
            onGenerateRoute: (settings) {
              print(settings.arguments);
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

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['flutterio', 'beautiful apps'],
  contentUrl: 'https://flutter.io',

  childDirected: false,
  testDevices: <String>[], // Android emulators are considered test devices
);

BannerAd myBanner = BannerAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: BannerAd.testAdUnitId,
  size: AdSize.smartBanner,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("BannerAd event is $event");
  },
);
/*
InterstitialAd myInterstitial = InterstitialAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: InterstitialAd.testAdUnitId,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("InterstitialAd event is $event");
  },
);*/
