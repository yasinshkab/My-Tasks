import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_control/screens/auth/sign_up.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                IconButton(
                  icon: Icon(
                    size: 28,
                    Icons.arrow_circle_left_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                )
              ]),
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  child: Icon(
                    size: 75,
                    Icons.person,
                    color: grey,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Center(
                child: Text(
                  'Yaseen Eshkab',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              const Center(
                child: Text(
                  'Flutter Developer',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Divider(color: Colors.white54),
              const SizedBox(height: 16.0),
              const Text(
                'About Me',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'I am a passionate Flutter developer with 3 years of experience in building beautiful and functional mobile applications in diffrent fields. I enjoy creating seamless user experiences and working with the latest technologies to bring ideas to life.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16.0),
              const Divider(color: Colors.white54),
              const SizedBox(height: 16.0),
              const Text(
                'Contact Me',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8.0),
              const Row(
                children: <Widget>[
                  Icon(Icons.email, color: Colors.white70),
                  SizedBox(width: 8.0),
                  Text(
                    'your.email@example.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Row(
                children: <Widget>[
                  Icon(Icons.phone, color: Colors.white70),
                  SizedBox(width: 8.0),
                  Text(
                    '+1234567890',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Row(
                children: <Widget>[
                  Icon(Icons.web, color: Colors.white70),
                  SizedBox(width: 8.0),
                  Text(
                    'www.yourwebsite.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
