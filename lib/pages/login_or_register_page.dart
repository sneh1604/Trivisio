import "package:flutter/material.dart";
import '/images/login_page.dart' as images;
import 'register_page.dart' as pages;

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({Key? key}) : super(key: key);
  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  @override
  bool showLoginPage = true;

  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return images.LoginPage(
        onTap: togglePage,
      );
    } else {
      return pages.RegisterPage(onTap: togglePage);
    }
  }
}
