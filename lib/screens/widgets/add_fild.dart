import 'package:flutter/material.dart';

import '../auth/sign_up.dart';

class AddInputField extends StatelessWidget {
  final bool focus;
  final VoidCallback onTap;
  final VoidCallback onTapOutSide;
  final String hint;
  final double? width;
  // final double? height;
  final int? minlines;
  final int? maxlines;
  final TextEditingController? controller;

  const AddInputField({
    super.key,
    required this.focus,
    required this.onTap,
    required this.onTapOutSide,
    required this.hint,
    required this.width,
    this.controller,
    this.minlines,
    this.maxlines,

    // this.height
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: width,
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: focus ? const Color.fromRGBO(0, 204, 102, 1) : null,
      ),
      child: TextFormField(
        minLines: minlines ?? 1,
        maxLines: maxlines ?? 1,
        controller: controller,
        onTap: onTap,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
          onTapOutSide();
        },
        onChanged: (value) {},
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          filled: true,
          fillColor: primaryColor,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          hoverColor: const Color.fromRGBO(0, 204, 102, 1),
          hintText: hint,
          hintStyle: const TextStyle(
              color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 12),
        ),
      ),
    );
  }
}
