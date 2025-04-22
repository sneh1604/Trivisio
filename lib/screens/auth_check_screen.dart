// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sample_login/services/auth_service.dart';
import 'package:sample_login/screens/auth_check_screen.dart';
import 'package:sample_login/screens/home_screen.dart';
import 'package:sample_login/screens/login_screen.dart';

class AuthCheckScreen extends StatelessWidget {
  const AuthCheckScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if( snapshot.hasData){
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        }
      ),

    );
  }
}
