import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: content());
  }

  Widget content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          height: 400,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Image.asset(
              "assets/1.png",
              fit: BoxFit.contain,
              width: double.infinity,
              height: 50,
            ),
          ),
        ),
        const SizedBox(height: 50),

        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed("/survey");
          },
          child: LoginButton(title: "Be a Donor"),
        ),

        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed("/bloodRequest");
          },
          child: LoginButton(title: "Request Blood"),
        ),

        const SizedBox(height: 30),
        const Text(
          "Already have a donor profile?",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(137, 0, 0, 0),
          ),
        ),
        const SizedBox(height: 10),

        // Navigate to the Donor Profile Edit page
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              '/editDonorProfile',
            ); // Navigate to the Edit Donor Profile page
          },
          child: LoginButton(title: "Edit your donor profile"),
        ),

        const SizedBox(
          height: 10,
        ), // Space between the button and Learn More text
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed("/about");
          },
          child: const Text(
            "Learn More",
            style: TextStyle(
              color: Color.fromARGB(255, 255, 17, 0),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  final String title;

  const LoginButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 0, 0),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
