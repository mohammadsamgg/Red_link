import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:red_link/profile_creation.dart';

class Survey extends StatefulWidget {
  const Survey({super.key});

  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonWidth = size.width * 0.35;
    final buttonHeight = size.height * 0.08;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.30,
                child: Lottie.asset("assets/Blood_a.json"),
              ),
              Text(
                "Pick your\nBlood type",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.08,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  for (var type in [
                    'A+',
                    'A-',
                    'B+',
                    'B-',
                    'AB+',
                    'AB-',
                    'O+',
                    'O-',
                  ])
                    _bloodTypeButton(type, buttonWidth, buttonHeight),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bloodTypeButton(String text, double width, double height) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileCreationPage(bloodType: text),
          ),
        );
      },
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
