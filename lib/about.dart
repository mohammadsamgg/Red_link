import 'package:flutter/material.dart';
import 'package:red_link/blood_requests.dart';
import 'package:red_link/survey.dart';

// ignore: use_key_in_widget_constructors
class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: content(context), // Pass context for navigation
    );
  }

  Widget content(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center align content
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Center(
            child: Image.asset(
              "assets/blood-type.png", // Replace with an appropriate image
              height: 200,
              color: Colors.red,
            ),
          ),
        ),
        const SizedBox(height: 40), // Space between icon and text
        const Text(
          "Welcome to Redlink",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 30), // Space between title and description
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            "RedLink, the application that connects blood donors with those in urgent need. Our mission is to make blood donation seamless and accessible, saving lives and spreading hope across communities.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(136, 0, 0, 0),
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ), // Space between description and action buttons
        const Text(
          "How You Can Help:",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 10), // Space between section and buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Handle Donate Blood action
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Survey()),
                );
              },
              child: actionButton("Donate Blood"),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                // Handle Request Blood action
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BloodRequestPage()),
                );
              },
              child: actionButton("Request Blood"),
            ),
          ],
        ),
        const SizedBox(height: 15), // Space at the bottom
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            "Together, we can save lives. Join us in our mission to make the world a better place, one donation at a time.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  // Action Button Widget
  Widget actionButton(String text) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(50),
      ),
      height: 70,
      width: 150,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
