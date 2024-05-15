import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String email, password;
  final formkey = GlobalKey<FormState>();
  final firebaseauth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff21254A),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleText(),
                      customSizedBox(),
                      emailTextField(),
                      customSizedBox(),
                      passwordTextField(),
                      customSizedBox(),
                      signUpButton(),
                      customSizedBox(),
                      backToLoginPage(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
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
        decoration: const InputDecoration(
          hintText: "Şifre",
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none, // Alt çizgiyi kaldırır
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        ),
      ),
    );
  }

  Center signUpButton() {
    return Center(
      child: TextButton(
        onPressed: signUp,
        child: Container(
          height: 50,
          width: 150,
          margin: const EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color(0xff31274F),
          ),
          child: const Center(
            child: Text(
              "Hesap Oluştur",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> signUpHataYakalama(String email, String password) async {
    String? res;
    try {
      final result = await firebaseauth.createUserWithEmailAndPassword(
          email: email, password: password);
      res = "success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          res = "Lütfen doğru email biçiminde girin";
          break;
        case "email-already-in-use":
          res = "Bu Email Zaten Kullanımda";
          break;
        case "weak-password":
          res = "Lütfen 6 karakter üstünde bir parola giriniz";
          break;
        default:
          res = 'Hata kodu: ${e.code}';
          break;
      }
    }
    return res;
  }

  void signUp() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      final result = await signUpHataYakalama(email, password);
      if (result == 'success') {
        try {
          Navigator.pushReplacementNamed(context, "/loginPage");
        } catch (e) {
          if (e is FirebaseAuthException) {
            // Eğer email already in use hatası alırsanız, bunu kullanıcıya gösterin
            if (e.code == 'email-already-in-use') {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Hata'),
                    content: const Text('Bu email zaten kullanılıyor.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Geri dön'),
                      ),
                    ],
                  );
                },
              );
            }
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Hata'),
                  content: Text(e.toString()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Geri dön'),
                    ),
                  ],
                );
              },
            );
          }
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
                  child: const Text('Geri dön'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Center backToLoginPage() {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, "/loginPage"),
        child: Container(
          height: 50,
          width: 150,
          margin: const EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color(0xff31274F),
          ),
          child: const Center(
            child: Text(
              "Giriş Sayfasına Geri Dön",
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }

  Text titleText() {
    return const Text(
      "       Funree Evrenine\n             Kayıt Ol!",
      style: TextStyle(
          fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
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
