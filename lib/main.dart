import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth import
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:girisyapbackend/pages/auth/forgot_password.dart';
import 'package:girisyapbackend/pages/auth/login_page.dart';
import 'package:girisyapbackend/pages/auth/sign_up.dart';
import 'package:girisyapbackend/pages/home_page.dart';
import 'package:lottie/lottie.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final firestore = FirebaseFirestore.instance;
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emirhan Eren',
      home: const AuthWrapper(), // AuthWrapper kullanıyoruz
      routes: {
        "/loginPage": (context) => const LoginPage(),
        "/signUp": (context) => const SignUp(),
        "/homePage": (context) => const HomePage(),
        "/forgotPassword": (context) => const ForgotPassword(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return const HomePage(); // Kullanıcı oturum açmışsa HomePage'e yönlendirilir
        }
        return const MainPage(); // Kullanıcı oturum açmamışsa LoginPage'e yönlendirilir
      },
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Arka planda animasyon
          Lottie.asset(
            'assets/animations/example.json',
            width: screenSize.width,
            height: screenSize.height,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text(
                  'Animasyon yüklenemedi: $error',
                  style: TextStyle(color: Colors.red),
                ),
              );
            },
          ),
          // Ön planda içerik
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Funree Evrenine \n      Hoşgeldin \n         Yolcu!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color(0xff31274F), // Buton arka plan rengi
                        minimumSize: Size(150, 50), // Butonun minimum boyutu
                        padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15), // Buton içindeki boşluklar
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/loginPage");
                      },
                      child: const Text(
                        "Giriş Yap",
                        style: TextStyle(color: Colors.white), // Yazı rengi
                      ),
                    ),
                    customSizedBox(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color(0xff31274F), // Buton arka plan rengi
                        minimumSize: Size(150, 50), // Butonun minimum boyutu
                        padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15), // Buton içindeki boşluklar
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/signUp");
                      },
                      child: const Text(
                        "Kayıt Ol",
                        style: TextStyle(color: Colors.white), // Yazı rengi
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget customSizedBox() => const SizedBox(
        height: 30,
        width: 20,
      );
}
