import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:girisyapbackend/service/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? fullName = "";
  final AuthService _authService = AuthService();
  String? currentUsername; // Kullanıcı adını saklamak için değişken

  @override
  void initState() {
    super.initState();
    userNameGetFirestore().then((value) {
      setState(() {
        currentUsername = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hoşgeldin $currentUsername"),
            const SizedBox(height: 20),
            Text("DEVELOPED BY BEKER SOFT"),
            const SizedBox(height: 20),
            TextButton(
              onPressed: logOut,
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
                    "Çıkış Yap",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String?> userNameGetFirestore() async {
    String currentUserId = _authService.getCurrentUser()!.uid;

    DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(currentUserId)
        .get();

    if (userDoc.exists) {
      return userDoc.data()?['fullName'];
    } else {
      return "Kullanıcı bulunamadı";
    }
  }

  void logOut() async {
    await _authService.signOut(); // Kullanıcı çıkış yapma işlemi
    Navigator.pushReplacementNamed(context, "/loginPage");
  }
}
