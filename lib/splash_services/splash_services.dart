import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../ui/firestore_database/firestore_list_screen.dart';
import '../ui/login_screen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final fAuth = FirebaseAuth.instance;
    final user = fAuth.currentUser;

    if (user != null) {
      Timer(
          const Duration(seconds: 5),
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FirestoreScreen())));
    } else {
      Timer(
          const Duration(seconds: 5),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())));
    }
  }
}
