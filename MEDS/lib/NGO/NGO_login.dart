import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import
import 'NGO_Home_Page.dart';
import 'ngo_signup.dart';

class NGOLoginPage extends StatefulWidget {
  @override
  _NGOLoginPageState createState() => _NGOLoginPageState();
}

class _NGOLoginPageState extends State<NGOLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Function to validate login using Firestore
  Future<void> _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in both fields.')),
      );
      return;
    }

    try {
      // Query Firestore to check if the email exists
      var querySnapshot = await FirebaseFirestore.instance
          .collection("NGO_Users") // Firestore collection for NGOs
          .where("Email", isEqualTo: emailController.text)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // If no document is found with the provided email
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email not found. Please check or sign up.')),
        );
        return; // Exit if email doesn't exist
      }

      // Validate password
      var userDoc = querySnapshot.docs.first; // Get the first matching document
      String storedPassword = userDoc["Password"];

      if (storedPassword == passwordController.text) {
        // Password matches, navigate to the NGO Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NGODashboardPage()),
        );
      } else {
        // Password does not match
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect password. Please try again.')),
        );
      }
    } catch (e) {
      // Handle any errors (e.g., Firestore issues or network problems)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NGO Login Page", style: Theme.of(context).textTheme.headlineLarge),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Not a member? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NGOSignUpPage()),
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
