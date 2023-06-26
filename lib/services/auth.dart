import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../interfaces/home.dart';
import '../interfaces/login.dart';

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MyHomePage(
              title: 'Home',
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: Text('No Internet'),
            );
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
