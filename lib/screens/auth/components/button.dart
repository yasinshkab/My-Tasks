import 'package:flutter/material.dart';

class AccountButton extends StatelessWidget {
  final String text;
  final bool loading;
  final VoidCallback onTap;
  final String? tag;
  const AccountButton(
      {super.key,
      required this.text,
      required this.loading,
      required this.onTap,
      this.tag});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag ?? "TAG",
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.height * 1,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            // gradient: const LinearGradient(
            //     colors: [Colors.purpleAccent, Colors.pinkAccent])
            color: const Color.fromRGBO(0, 204, 102, 1),
          ),
          child: loading
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Material(
                  color: Colors.transparent,
                  child: Text(
                    text,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
        ),
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  final String text;
  final bool loading;
  final VoidCallback onTap;
  final String? tag;
  const DeleteButton(
      {super.key,
      required this.text,
      required this.loading,
      required this.onTap,
      this.tag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.height * 0.2,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // gradient: const LinearGradient(
          //     colors: [Colors.purpleAccent, Colors.pinkAccent])
          color: const Color.fromRGBO(79, 79, 79, 0.8),
        ),
        child: loading
            ? const SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Material(
                color: Colors.transparent,
                child: Text(
                  text,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  final String text;
  final bool loading;
  final VoidCallback onTap;
  final String? tag;
  const EditButton(
      {super.key,
      required this.text,
      required this.loading,
      required this.onTap,
      this.tag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.height * 0.2,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // gradient: const LinearGradient(
          //     colors: [Colors.purpleAccent, Colors.pinkAccent])
          color: const Color.fromRGBO(0, 204, 102, 1),
        ),
        child: loading
            ? const SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Material(
                color: Colors.transparent,
                child: Text(
                  text,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }
}
