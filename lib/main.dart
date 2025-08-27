import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// App Screens
import 'package:red_link/splash.dart';
import 'package:red_link/login.dart';
import 'package:red_link/survey.dart';
import 'package:red_link/about.dart';
import 'package:red_link/profile_creation.dart';
import 'package:red_link/blood_requests.dart';
import 'package:red_link/edit_donor_profile.dart';

// Firebase Options
import 'package:red_link/Firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const RedLinkApp());
}

class RedLinkApp extends StatelessWidget {
  const RedLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RedLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Splash(),
        '/login': (context) => const Login(),
        '/survey': (context) => const Survey(),
        '/about': (context) => const About(),
        '/profile_creation':
            (context) => const ProfileCreationPage(bloodType: 'A'),
        '/bloodRequest': (context) => const BloodRequestPage(),
        '/editDonorProfile': (context) => const EditDonorProfile(),
      },
    );
  }
}
