import 'package:flutter/material.dart';
import 'package:task_control/screens/auth/components/signin_body.dart';
import 'package:task_control/screens/auth/sign_up.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: SignInBody(),
      ),
    );
  }
}
