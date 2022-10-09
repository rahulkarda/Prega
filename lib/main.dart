// import 'package:prega/pages/signin_page.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prega/pages/splash_screen.dart';
import 'package:prega/provider/google_signin.dart';
import 'package:provider/provider.dart';

Future main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: (MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
        )),
      );
}
