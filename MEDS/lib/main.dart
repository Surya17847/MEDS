import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Import the home screen
import 'package:my_first_app/splash_screen.dart'; // Import SplashScreen
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Enable Firestore offline persistence
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MEDS",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFFC2005D),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFC2005D),
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'button'),
          ),
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontFamily: 'heading', fontSize: 25, color: Colors.white),
          bodyMedium: TextStyle(fontFamily: 'BodyFont'),
        ),
      ),
      home: AuthenticationScreen(), // Start with the Authentication Screen
    );
  }
}

class AuthenticationScreen extends StatefulWidget {
  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool isBiometricEnabled = false; // Track if biometric authentication is enabled

  @override
  void initState() {
    super.initState();
    _checkBiometric(); // Check biometric toggle
  }

  // Check if biometric authentication is enabled
  Future<void> _checkBiometric() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isBiometricEnabled = prefs.getBool('biometric_enabled') ?? false; // Retrieve saved state

    if (isBiometricEnabled) {
      await _authenticateUser();  // Call biometric authentication
    } else {
      // Directly navigate to SplashScreen if biometric is off
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()), // Move to SplashScreen
      );
    }
  }

  // Method to handle biometric authentication
  Future<void> _authenticateUser() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print("Error during authentication: $e");
    }

    if (authenticated) {
      // Navigate to SplashScreen after successful authentication
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()), // Move to SplashScreen
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Authentication failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Loading indicator while authentication happens
      ),
    );
  }
}
