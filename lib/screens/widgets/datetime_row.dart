import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:task_control/controller/add_task_controller.dart';
import 'package:task_control/screens/auth/sign_up.dart';

class DateTimeRow extends StatelessWidget {
  final controller = Get.put(AddTaskController());
  DateTimeRow({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Date',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(() => DateTimeContainer(
                  text: controller.date.value.isEmpty
                      ? 'dd/mm/yyyy'
                      : controller.date.value,
                  icon: const Icon(
                    FontAwesomeIcons.calendar,
                    color: Colors.white24,
                    size: 20,
                  ),
                  onTap: () {
                    controller.pickDate(context);
                  },
                ))
          ],
        ),
        Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: 'Time',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
              TextSpan(
                text: '   (optional)',
                style: TextStyle(color: Colors.white30, fontSize: 13),
              )
            ])),
            const SizedBox(
              height: 10,
            ),
            Obx(() => DateTimeContainer(
                  text: controller.time.value.isEmpty
                      ? 'hh/mm'
                      : controller.time.value,
                  icon: const Icon(
                    Icons.watch,
                    color: Colors.white24,
                    size: 20,
                  ),
                  onTap: () {
                    controller.pickTime(context);
                  },
                ))
          ],
        )
      ],
    );
  }
}

class DateTimeContainer extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback onTap;
  const DateTimeContainer(
      {super.key, required this.text, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: size.width / 2.5,
        decoration: BoxDecoration(
            color: primaryColor, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            // Icon(
            //   FontAwesomeIcons.calendar,
            //   color: Colors.white24,
            //   size: 20,
            // ),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
