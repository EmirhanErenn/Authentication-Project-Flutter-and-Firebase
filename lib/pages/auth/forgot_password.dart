import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late String email = "";
  late String password = "";
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
                        forgotPasswordButton(),
                        customSizedBox(),
                        backToLoginPage(),
                        customSizedBox(),
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
      "Merhaba,\nHoşgeldin!",
      style: TextStyle(
          fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  TextEditingController _emailController = TextEditingController();

  //Araştırılacak

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
        controller: _emailController,
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
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: const InputDecoration(
          hintText: "E-mail",
          hintStyle: TextStyle(color: Colors.white),
          border:
              InputBorder.none, // TextFormField'ın kendi border'ını kaldırın
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        ),
      ),
    );
  }

  Center forgotPasswordButton() {
    return Center(
      child: TextButton(
        onPressed: forgotPassword,
        child: const Text(
          "Şifremi Unuttum",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void forgotPassword() async {
    try {
      await firebaseauth.sendPasswordResetEmail(
          email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text(
                'Şifre Yenileme linki gönderildi. Lütfen Email Gelen Kutunuzu Kontrol Ediniz'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Lütfen email kısmını bos bırakmayınız'),
            );
          });
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
