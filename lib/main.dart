import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_control/data/middleware.dart';
import 'package:task_control/screens/OnBoardings/on_boarding.dart';
import 'package:task_control/firebase_options.dart';
import 'package:task_control/screens/main%20screen/mainscreen.dart';
import 'package:task_control/screens/auth/sign_in.dart';
import 'package:task_control/data/services.dart';
import 'package:task_control/screens/auth/sign_up.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:page_transition/page_transition.dart'; // Import this for pageTransitionType

void main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance;
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.manual,
  //   overlays: [
  //     SystemUiOverlay.bottom,
  //   ],
  // );

  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: primaryColor, // Set the background color of the status bar
  //   statusBarIconBrightness:
  //       Brightness.light, // Use white icons for the status bar
  //   statusBarBrightness:
  //       Brightness.dark, // Needed for iOS to ensure light icons
  //   systemNavigationBarColor:
  //       Colors.white, // Optional: Set navigation bar color
  //   systemNavigationBarIconBrightness:
  //       Brightness.dark, // Optional: Set navigation bar icons to dark
  // ));

  tz.initializeTimeZones();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // initialBinding: AppBindings(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'alamari',
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.grey,
        ),
        textTheme: const TextTheme(
            // titleLarge: GoogleFonts.mavenPro(
            //   color: Colors.black,
            //   fontWeight: FontWeight.bold,
            //   fontSize: 25,
            // ),
            // titleMedium: GoogleFonts.mavenPro(
            //   color: Colors.black,
            //   fontSize: 16,
            // ),
            // titleSmall: GoogleFonts.mavenPro(
            //   color: Colors.grey,
            //   fontSize: 13,
            // ),
            ),
      ),
      getPages: [
        //   //main
        GetPage(name: "/main", page: () => HomePage()),

        //auth
        GetPage(name: "/m", page: () => const OnBoardingScreen(), middlewares: [
          MyMiddleWare(),
        ]),

        GetPage(name: "/login", page: () => const SignIn()),
      ],
      home: AnimatedSplashScreen(
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: primaryColor,
        splash: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Image.asset(
              'assets/images/Screenshot__175.png',
              width: 400,
              height: 400,
              fit: BoxFit.contain,
            ),
          ),
        ),
        nextScreen: const OnBoardingScreen(),
        nextRoute: "/m",
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}
