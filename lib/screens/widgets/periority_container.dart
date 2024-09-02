import 'package:flutter/material.dart';
import 'package:task_control/screens/auth/sign_up.dart';

class PeriorityContainer extends StatelessWidget {
  final VoidCallback onTap;
  final bool focus;
  final String type;
  const PeriorityContainer(
      {super.key,
      required this.onTap,
      required this.focus,
      required this.type});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width / 2.5,
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: focus
                ? const LinearGradient(colors: [
                    Color.fromRGBO(0, 204, 102, 1),
                    Color.fromARGB(255, 0, 138, 69)
                  ])
                : null),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            height: 40,
            width: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: primaryColor),
            child: Text(
              type,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
