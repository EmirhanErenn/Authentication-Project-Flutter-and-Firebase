import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:girisyapbackend/pages/auth/forgot_password.dart';
import 'package:girisyapbackend/pages/auth/login_page.dart';
import 'package:girisyapbackend/pages/auth/sign_up.dart';
import 'package:girisyapbackend/pages/home_page.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emirhan Eren',
      home: const Directionality(
        textDirection: TextDirection.ltr,
        child: LoginPage(),
      ),
      routes: {
        "/loginPage": (context) => const LoginPage(),
        "/signUp": (context) => const SignUp(),
        "/homePage": (context) => const HomePage(),
        "/forgotPassword": (context) => const ForgotPassword(),
      },
    );
  }
}
