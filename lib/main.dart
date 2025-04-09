import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:red_link/edit_donor_profile.dart';
import 'package:red_link/blood_requests.dart';
import 'package:red_link/firebase_options.dart';
import 'package:red_link/profile_creation.dart';
import 'package:red_link/splash.dart';
import 'package:red_link/login.dart';
import 'package:red_link/survey.dart';
import 'package:red_link/about.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      initialRoute: '/', // Ensures the app starts at Splash screen
      routes: {
        '/': (context) => Splash(),
        '/login': (context) => Login(),
        '/survey': (context) => Survey(),
        '/about': (context) => About(),
        '/profile_creation': (context) => ProfileCreationPage(bloodType: 'A'),
        '/bloodRequest': (context) => BloodRequestPage(),
        '/editDonorProfile': (context) {
          final donorId =
              ModalRoute.of(context)?.settings.arguments as String? ??
              ''; // Fetch the donorId passed during navigation
          return EditDonorProfile(
            donorId: donorId,
          ); // Pass donorId to EditDonorProfile
        },
      },
    ),
  );
}
