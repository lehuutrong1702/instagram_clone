import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/reponsive/mobile_screen_layout.dart';
import 'package:instagram_clone/reponsive/reponsive_layout_screen.dart';
import 'package:instagram_clone/reponsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/login_screen.dart';

import 'package:instagram_clone/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      // home: ReponsiveLayout(
      //   webScreenlayout: WebScreenLayout(),
      //   mobileScreenlayout: MobileScreenLayout(),
      // ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const ReponsiveLayout(
                webScreenlayout: WebScreenLayout(),
                mobileScreenlayout: MobileScreenLayout(),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
              ));
            } else if (snapshot.hasError) {
              Center(
                child: Text('${snapshot.error}'),
              );
            }
            return const LoginScreen();
          }),
    );
  }
}
