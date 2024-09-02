import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth/sign_up.dart';

class AddCategories extends StatefulWidget {
  const AddCategories({super.key});

  @override
  State<AddCategories> createState() => _AddCategoriesState();
}

class _AddCategoriesState extends State<AddCategories> {
  IconData? _selectedIcon;

  void _chooseIcon() async {
    final IconData? icon = await showDialog<IconData>(
      context: context,
      builder: (BuildContext context) {
        return IconPickerDialog();
      },
    );

    if (icon != null) {
      setState(() {
        _selectedIcon = icon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color selectedColor = Colors.blue; // default color
    const List<Color> listColor = <Color>[
      Color(0xFFF56287),
      Color(0xFF37B34A),
      Color(0xFF1488CC),
      Color(0xFFE0B719),
      Color(0xffB455FF),
      Color(0xff07BBC7),
      Color(0xffFF5A5A),
      Color.fromARGB(255, 162, 147, 84),
      Color.fromARGB(255, 85, 255, 210),
      Color.fromARGB(255, 71, 7, 199),
      Color.fromARGB(255, 255, 170, 90),
    ];

    return Scaffold(
      backgroundColor: black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_circle_left_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Create new category',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(height: 20),
              const Text(
                'Category name :',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 17),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Category icon :',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 17),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                  onTap: _chooseIcon,
                  child: Container(
                    decoration: BoxDecoration(
                        color: grey, borderRadius: BorderRadius.circular(12)),
                    // width: 180,
                    // height: 60,
                    child: _selectedIcon != null
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(
                              _selectedIcon,
                              size: 24,
                              color: Colors.white,
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Choose icon from library",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  )),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Category color :',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 17),
              ),
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: listColor.map((color) {
                    bool isSelected = selectedColor == color;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = color;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          border: Border.all(
                            color: isSelected ? grey : Colors.transparent,
                            width: isSelected ? 1.0 : 0.0,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconPickerDialog extends StatelessWidget {
  final List<IconData> icons = [
    Icons.home,
    Icons.star,
    Icons.favorite,
    Icons.person,
    Icons.settings,
    Icons.access_alarm,
    Icons.account_balance,
    Icons.cake,
  ];

  IconPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
            color: grey, borderRadius: BorderRadius.all(Radius.circular(20))),
        height: 300,
        child: GridView.builder(
          padding: const EdgeInsets.all(1),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: icons.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context, icons[index]);
              },
              child: Icon(
                icons[index],
                size: 44,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}
