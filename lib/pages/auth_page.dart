import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sample_login/pages/login_or_register_page.dart';
import 'home_page.dart';
import '/images/login_page.dart';



class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key); // updated
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if( snapshot.hasData){
            return HomePage();
          } else {
            return LoginOrRegisterPage();
          }
        }
      ),

    );
  }
}
