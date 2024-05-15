import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email, password;
  final formkey = GlobalKey<FormState>();
  final firebaseauth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xff21254A),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height * .25,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/topImage.png"),
                )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formkey,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        titleText(),
                        customSizedBox(),
                        emailTextField(),
                        customSizedBox(),
                        passwordTextField(),
                        customSizedBox(),
                        signInButton(),
                        customSizedBox(),
                        forgotPasswordButton(),
                        customSizedBox(),
                        signUpButton(),
                        customSizedBox(),
                        signInAnonymousButton(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Text titleText() {
    return const Text(
      "Funree Evrenine\n      Giriş Yap!",
      style: TextStyle(
          fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  Container emailTextField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
            10.0), // İstediğiniz border radius'u ayarlayın
        border: Border.all(
          color: Colors.grey, // İstediğiniz border rengini belirleyin
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
          border: InputBorder.none, // Alt çizgiyi kaldırır
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        ),
      ),
    );
  }

  Container passwordTextField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
            10.0), // İstediğiniz border radius'u ayarlayın
        border: Border.all(
          color: Colors.grey, // İstediğiniz border rengini belirleyin
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
        obscureText: true,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Şifre",
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none, // Alt çizgiyi kaldırır
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        ),
      ),
    );
  }

  Center forgotPasswordButton() {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, "/forgotPassword"),
        child: const Text(
          "Şifreni mi Unuttun?",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Center signUpButton() {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, "/signUp"),
        child: const Text(
          "Hesap Oluştur",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Center signInAnonymousButton() {
    return Center(
      child: TextButton(
        onPressed: signInAnonymous,
        child: const Text(
          "Misafir Girişi",
          style: TextStyle(
            color: Colors.white,
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
          width: 150,
          margin: const EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: const Color(0xff31274F)),
          child: const Center(
            child: Text(
              "Giriş Yap",
              style: TextStyle(
                color: Colors.white,
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
      final result = await signInHataYakalama(email, password);
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
