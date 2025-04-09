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
    return Scaffold(body: content());
  }

  Widget content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center align content
      children: [
        // Lottie Animation Added Here
        // ignore: sized_box_for_whitespace
        Container(
          height: 250, // Adjust size as needed
          child: Lottie.asset(
            "assets/Blood_a.json",
          ), // Ensure the path is correct
        ),
        const SizedBox(height: 5), // Space between animation and text
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: const Text(
            "Pick your\nBlood type",
            textAlign: TextAlign.center, // Center-align text
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              wordSpacing: -1.0,
            ),
          ),
        ),
        const SizedBox(height: 10), // Space between text and buttons
        // First Row of Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buttonContainer("A+"),
            const SizedBox(width: 20),
            buttonContainer("A-"),
          ],
        ),
        const SizedBox(height: 20), // Space between rows
        // Second Row of Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buttonContainer("B+"),
            const SizedBox(width: 20),
            buttonContainer("B-"),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buttonContainer("AB+"),
            const SizedBox(width: 20),
            buttonContainer("AB-"),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buttonContainer("O+"),
            const SizedBox(width: 20),
            buttonContainer("O-"),
          ],
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  // Button Container Widget
  Widget buttonContainer(String text) {
    return GestureDetector(
      onTap: () {
        // Navigate to Profile Creation Page with selected blood type
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileCreationPage(bloodType: text),
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(50),
        ),
        height: 70,
        width: 200,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 22,
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
