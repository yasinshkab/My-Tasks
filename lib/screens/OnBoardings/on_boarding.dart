import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';
import 'package:task_control/screens/OnBoardings/first_page.dart';
import 'package:task_control/screens/auth/sign_up.dart';
import 'package:task_control/data/services.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    Get.put(MyServices());

    super.initState();
  }

  ///يغير لون الشريط متع البطارية
  var boardingController = PageController();
  String a = "Next";
  MyServices myServices = Get.find();
  bool isLast = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Column(children: [
          Expanded(
            child: PageView.builder(
              onPageChanged: (int index) {
                if (index == boarding.length - 1) {
                  setState(() {
                    isLast = true;
                  });
                } else {
                  setState(() {
                    isLast = false;
                  });
                }
                if (isLast) {
                  a = "Get Started";
                } else {
                  a = "Next";
                }
              },
              physics: const BouncingScrollPhysics(),
              controller: boardingController,
              itemBuilder: (context, index) =>

                  //on boarding item
                  buildBoardingItem(boarding[index]),
              itemCount: boarding.length,
            ),
          ),
          const SizedBox(
            height: 45,
          ),
          SmoothPageIndicator(
            controller: boardingController,
            count: boarding.length,
            effect: const ExpandingDotsEffect(
              dotColor: Colors.grey,
              activeDotColor: Color.fromRGBO(0, 204, 102, 1),
              dotHeight: 6.25,
              dotWidth: 12.5,
              spacing: 5,
            ),
          ),
          const SizedBox(
            height: 45,
          ),
          //button
          //controller///////////////////////////
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    //  if (isLast) {
                    //               myServices.sharedPreferences.setString("step", "1");
                    //               Get.to(FirstPage());
                    //             } else {
                    boardingController.previousPage(
                        duration: const Duration(
                          milliseconds: 750,
                        ),
                        curve: Curves.decelerate);
                    //  }
                  },
                  child: const Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white38,
                    ),
                  )),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  if (isLast) {
                    myServices.sharedPreferences.setString("step", "1");
                    Get.to(const FirstPage());
                  } else {
                    boardingController.nextPage(
                        duration: const Duration(
                          milliseconds: 750,
                        ),
                        curve: Curves.decelerate);
                  }
                },
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    // width: 80,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(0, 204, 102, 1),
                        borderRadius: BorderRadius.circular(16)),
                    child:
                        // const SizedBox(width: 128),
                        Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                      child: Text(
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        a,
                      ),

                      // const Icon(
                      //   Icons.arrow_forward_ios,
                      //   color: Colors.white,
                      //   size: 32,
                      // ),
                      // const SizedBox(width: 20,)
                    )),
              )
            ],
          ),

          const SizedBox(
            height: 50,
          ),
        ]),
      ),
    );
  }
}

List<BoardingModel> boarding = [
  BoardingModel(
    title: "Streamline your work",
    subtit: "Keep your work tasks organized and stay productive with MyTasks.",
    image: "assets/images/cuate.png",
  ),
  BoardingModel(
    title: "Create daily routine",
    subtit:
        "In MyTasks  you can create your personalized routine to stay productive",
    image: "assets/images/cuate1.png",
  ),
  BoardingModel(
    title: "Keep track of your Tasks",
    subtit: "Keep track of your progress and never miss a deadline",
    image: "assets/images/cuate2.png",
  ),
];

class BoardingModel {
  late final String title;
  late final String image;
  late final String subtit;
  BoardingModel({
    required this.title,
    required this.image,
    required this.subtit,
  });
}

Widget buildBoardingItem(BoardingModel model) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Image(
                //  height: MediaQuery.of(context).size.height * 0.6,
                //   width: MediaQuery.of(context).size.width * 0.96,
                image: AssetImage(
              model.image,
            )),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  model.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'alamari',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  model.subtit,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'alamari',
                    height: 1.5,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
