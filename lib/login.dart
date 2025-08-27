import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(child: content(context)),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: size.height * 0.4,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Image.asset("assets/1.png", fit: BoxFit.contain),
        ),

        // Be a Donor Button
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed("/survey");
          },
          child: LoginButton(title: "Be a Donor"),
        ),

        const SizedBox(height: 20),

        // Request Blood Button
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed("/bloodRequest");
          },
          child: LoginButton(title: "Request Blood"),
        ),

        const SizedBox(height: 40),

        // Already have a donor profile?
        const Text(
          "Already have a donor profile?",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Color.fromARGB(99, 0, 0, 0),
          ),
        ),
        const SizedBox(height: 10),

        // Edit Donor Profile
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/editDonorProfile');
          },
          child: LoginButton(title: "Edit your donor profile"),
        ),

        const SizedBox(height: 20),

        // Learn More
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed("/about");
          },
          child: const Text(
            "Learn More",
            style: TextStyle(
              color: Color.fromARGB(255, 255, 0, 0),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  final String title;

  const LoginButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 60,
        width: width,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 0, 0),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
