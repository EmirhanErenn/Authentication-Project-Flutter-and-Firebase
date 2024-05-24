import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email, password;
  final formkey = GlobalKey<FormState>();
  final firestore = FirebaseFirestore.instance;
  final firebaseauth = FirebaseAuth.instance;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff21254A),
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
          SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * .25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          titleText(),
                          customSizedBox(),
                          emailTextField(),
                          customSizedBox(),
                          passwordTextField(),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: forgotPasswordButton(),
                          ),
                          signInButton(),
                          customSizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              signUpButton(),
                              signInAnonymousButton(),
                            ],
                          ),
                          customSizedBox(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text titleText() {
    return const Text(
      "Funree Evrenine\n      Giriş Yap!",
      style: TextStyle(
          fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  Container emailTextField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Bilgileri Eksiksiz Doldurunuz!";
          } else {
            return null;
          }
        },
        onSaved: (value) {
          email = value!;
        },
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: "E-mail",
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        ),
      ),
    );
  }

  Container passwordTextField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Bilgileri Eksiksiz Doldurunuz!";
          } else {
            return null;
          }
        },
        onSaved: (value) {
          password = value!;
        },
        obscureText: _obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Şifre",
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget forgotPasswordButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, "/forgotPassword"),
        child: const Text(
          "Şifreni mi Unuttun?",
          style: TextStyle(
            color: Colors.white,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Center signUpButton() {
    return Center(
      child: Container(
        height: 50,
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color(0xff31274F),
        ),
        child: TextButton(
          onPressed: () => Navigator.pushNamed(context, "/signUp"),
          child: const Center(
            child: Text(
              "Hesap Oluştur",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Center signInAnonymousButton() {
    return Center(
      child: Container(
        height: 50,
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color(0xff31274F),
        ),
        child: TextButton(
          onPressed: signInAnonymous,
          child: const Center(
            child: Text(
              "Misafir Girişi",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signInAnonymous() async {
    try {
      final result = await firebaseauth.signInAnonymously();
      if (result.user != null) {
        Navigator.pushReplacementNamed(context, "/homePage");
      } else {
        print("Misafir girişi başarısız oldu.");
      }
    } catch (e) {
      print("Anon error $e");
    }
  }

  Center signInButton() {
    return Center(
      child: TextButton(
        onPressed: signIn,
        child: Container(
          height: 50,
          width: 500,
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color(0xff31274F),
          ),
          child: const Center(
            child: Text(
              "Giriş Yap",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> signInHataYakalama(String email, String password) async {
    String? res;
    try {
      final result = await firebaseauth.signInWithEmailAndPassword(
          email: email, password: password);
      res = "success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email": // calısıyor
          res = "Lütfen e-mail adresinizi doğru formatta girin(@gmail.com)";
          break;
        case "invalid-credential":
          res = "Kullanıcı adı veya şifre hatalı!";
          break;
        case "invalid-credential":
          res = "Kullanıcı adı veya şifre hatalı!";
          break;
        case "user-disabled": // calısıyor
          res = "Kullanici Pasif";
          break;
        default:
          res = 'Failed with error code: ${e.code}';
          break;
      }
    }
    return res;
  }

  void signIn() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      showLoadingDialog();
      final result = await signInHataYakalama(email, password);
      Navigator.pop(context); // Loading göstergesini kapatır
      if (result == 'success') {
        try {
          final userResult = await firebaseauth.signInWithEmailAndPassword(
              email: email, password: password);
          Navigator.pushReplacementNamed(context, "/homePage");
          print(userResult.user!.email);
        } catch (e) {
          e.toString();
        }
      } else {
        formkey.currentState!.reset();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Hata'),
                content: Text(result!),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Geri dön'))
                ],
              );
            });
      }
    }
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Yükleniyor...", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget customSizedBox() => const SizedBox(
        height: 20,
      );

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
          color: Colors.grey,
        )));
  }
}
