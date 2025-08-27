import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:red_link/blood_requests.dart';
import 'package:red_link/survey.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(body: _buildContent(context, isMobile));
  }

  Widget _buildContent(BuildContext context, bool isMobile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: isMobile ? 0 : 100),
            child: Center(
              child: Lottie.asset(
                "assets/about.json",
                height: isMobile ? 100 : 180,
                fit: BoxFit.contain,
                frameRate: FrameRate.max,
                repeat: true,
                animate: true,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Welcome to Redlink",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 30),
            child: const Text(
              "RedLink, the application that connects blood donors with those in urgent need. Our mission is to make blood donation seamless and accessible, saving lives and spreading hope across communities.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            "How You Can Help:",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ActionButton(
                label: "Donate Blood",
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Survey()),
                    ),
              ),
              const SizedBox(width: 20),
              _ActionButton(
                label: "Request Blood",
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BloodRequestPage(),
                      ),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 30),
            child: const Text(
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
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(50),
        ),
        height: 70,
        width: 150,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
