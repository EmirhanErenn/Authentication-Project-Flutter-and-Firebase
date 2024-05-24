import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String email, password, fullName = '', confirmPassword, birthDate = '';
  late String? selectedSkill = 'Flutter';
  final formkey = GlobalKey<FormState>();
  final firestore = FirebaseFirestore.instance;
  final firebaseauth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  List<String> skills = ['Flutter', 'C#', 'Web'];
  bool _obscureText = true;
  bool _obscureConfirmText = true;

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titleText(),
                          customSizedBox(),
                          fullNameTextField(),
                          customSizedBox(),
                          emailTextField(),
                          customSizedBox(),
                          passwordTextField(),
                          customSizedBox(),
                          confirmPasswordTextField(),
                          customSizedBox(),
                          birthDateTextField(context),
                          customSizedBox(),
                          skillsDropdown(),
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
        ],
      ),
    );
  }

  Container emailTextField() {
    return buildContainer(
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
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: "E-mail",
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20d.0, vertical: 15.0),
        ),
      ),
    );
  }

  Container passwordTextField() {
    return buildContainer(
      child: TextFormField(
        controller: _passwordController,
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

  Container confirmPasswordTextField() {
    return buildContainer(
      child: TextFormField(
        controller: _confirmPasswordController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Bilgileri Eksiksiz Doldurunuz!";
          } else if (value != _passwordController.text) {
            return "Şifreler Uyuşmuyor!";
          } else {
            return null;
          }
        },
        obscureText: _obscureConfirmText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Şifre Tekrar",
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmText ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmText = !_obscureConfirmText;
              });
            },
          ),
        ),
      ),
    );
  }

  Container fullNameTextField() {
    return buildContainer(
      child: TextFormField(
        controller: _fullNameController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Bilgileri Eksiksiz Doldurunuz!";
          } else {
            setState(() {
              fullName = value;
            });
            return null;
          }
        },
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: "Ad Soyad",
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        ),
      ),
    );
  }

  Container birthDateTextField(BuildContext context) {
    return buildContainer(
      child: TextFormField(
        controller: _birthDateController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Bilgileri Eksiksiz Doldurunuz!";
          } else {
            setState(() {
              birthDate = value;
            });
            return null;
          }
        },
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            setState(() {
              _birthDateController.text =
                  "${pickedDate.toLocal()}".split(' ')[0];
            });
          }
        },
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: "Doğum Tarihi",
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        ),
      ),
    );
  }

  Container skillsDropdown() {
    return buildContainer(
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[800], // Dropdown menu background color
        ),
        child: DropdownButtonFormField<String>(
          value: selectedSkill,
          items: skills.map((String skill) {
            return DropdownMenuItem<String>(
              value: skill,
              child: Text(skill),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedSkill = value!;
            });
          },
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          ),
          hint: const Text(
            "Yetenekler",
            style:
                TextStyle(color: Colors.white), // Adjust this color if needed
          ),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Container buildContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: child,
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
      showLoadingDialog(context); // Yükleniyor dialog'unu göster
      final result = await signUpHataYakalama(email, password);
      if (result == 'success') {
        try {
          User? user = firebaseauth.currentUser;
          if (user != null) {
            await firestore.collection('users').doc(user.uid).set({
              'fullName': fullName,
              'email': email,
              'birthDate': birthDate,
              'skills': selectedSkill,
              'uid': user.uid,
            });
            hideLoadingDialog(context); // Yükleniyor dialog'unu kapat
            Navigator.pushReplacementNamed(context, "/homePage");
          } else {
            hideLoadingDialog(context); // Yükleniyor dialog'unu kapat
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Hata'),
                  content: const Text('Kullanıcı bilgileri alınamadı.'),
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
        } catch (e) {
          hideLoadingDialog(context); // Yükleniyor dialog'unu kapat
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
      } else {
        hideLoadingDialog(context); // Yükleniyor dialog'unu kapat
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

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog dışına tıklayınca kapanmaması için
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text("Hesap Oluşturuluyor..."),
              ),
            ],
          ),
        );
      },
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.pop(context); // Dialog'u kapatmak için
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
              "Giriş Sayfasına Dön",
              style: TextStyle(color: Colors.white, fontSize: 15),
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
        ),
      ),
    );
  }
}
