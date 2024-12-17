import 'package:flutter/material.dart';
import 'package:my_first_app/Recipients/Recipients_Home_page.dart';
import 'package:my_first_app/Recipients/recipients_signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In

class RecipientLoginPage extends StatefulWidget {
  @override
  _RecipientLoginPageState createState() => _RecipientLoginPageState();
}

class _RecipientLoginPageState extends State<RecipientLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Google Sign-In and Firebase Authentication
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Function to sign in with Google
  Future<void> _googleSignInMethod() async {
    try {
      // Start the Google Sign-In process
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        // Authenticate with Firebase using the Google sign-in credentials
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Create a new credential from the Google sign-in
        OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the credential
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        if (userCredential.user != null) {
          // Query Firestore to check if the email exists for Google login
          var querySnapshot = await FirebaseFirestore.instance
              .collection("Recipients_Users")
              .where("Email_Id", isEqualTo: googleUser.email)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            // If the email exists in Firestore, navigate to home page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RecipientsHomePage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Email not found in our records. Please sign up first.')),
            );
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: $e')),
      );
    }
  }

  // Function to check if the email exists in Firestore and validate the password
  Future<void> _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    try {
      // Query Firestore to check if email exists
      var querySnapshot = await FirebaseFirestore.instance
          .collection("Recipients_Users")
          .where("Email_Id", isEqualTo: emailController.text)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // If no document is found with the provided email
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email incorrect. Please try again.')),
        );
        return; // Email doesn't exist, return early
      }

      // If email exists, check the password
      var userDoc = querySnapshot.docs.first; // Get the first document
      String storedPassword = userDoc["Password"];

      if (storedPassword == passwordController.text) {
        // Password matches, proceed to login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RecipientsHomePage()),
        );
      } else {
        // Password doesn't match
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password incorrect. Please try again.')),
        );
      }
    } catch (e) {
      // Handle any errors (e.g., network issues, Firestore errors)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipient Login Page", style: Theme.of(context).textTheme.headlineLarge),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _googleSignInMethod,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/google.png', // Google icon in your assets
                    height: 24,
                  ),
                  SizedBox(width: 10),
                  Text('Log in with Google'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Not a member? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecipientSignUpPage()),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
