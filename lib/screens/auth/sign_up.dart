import 'package:flutter/material.dart';
import 'package:task_control/screens/auth/components/signup_body.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: SignupBody(),
      ),
    );
  }
}

const primaryColor = Color(0xff151414);
const black = Color(0xff0C090A);
const grey = Color(0xff252525);
const textgrey = Color(0xff9A9A9A);
const ligtstgrey = Color(0xffCFCFCF);
