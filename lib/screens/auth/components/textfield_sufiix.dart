import 'package:flutter/material.dart';
import 'package:task_control/screens/auth/sign_up.dart';

class TextFieldSufix extends StatelessWidget {
  const TextFieldSufix({super.key, required this.icon, this.size = 18});
  final IconData icon;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: black,
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(0, 204, 102, 1), offset: Offset(1, 0)),
              BoxShadow(
                  color: Color.fromRGBO(0, 204, 102, 1), offset: Offset(0, 1)),
              BoxShadow(
                  color: Color.fromRGBO(0, 204, 102, 1), offset: Offset(-1, 0)),
              BoxShadow(
                  color: Color.fromRGBO(0, 204, 102, 1), offset: Offset(0, -1)),
            ]),
        child: Icon(
          icon,
          color: Colors.white70,
          size: size,
        ),
      ),
    );
  }
}
