import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_first_app/Recipients/Recipients_Home_page.dart';

class RecipientSignUpPage extends StatefulWidget {
  @override
  _RecipientSignUpPageState createState() => _RecipientSignUpPageState();
}

class _RecipientSignUpPageState extends State<RecipientSignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Check if the email exists in Firestore
  Future<bool> emailExists(String email) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("Recipients_Users")
          .where("Email_Id", isEqualTo: email)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      log("Error checking email: $e");
      return false;
    }
  }

  // Add data to Firebase
  addData(String recipient_name, String recipient_email, String recipient_password, String recipient_age, String recipient_gender, String recipient_address) async {
    if (recipient_name.isEmpty ||
        recipient_email.isEmpty ||
        recipient_password.isEmpty ||
        recipient_age.isEmpty ||
        recipient_gender.isEmpty ||
        recipient_address.isEmpty) {
      log("Enter required Fields");
    } else {
      FirebaseFirestore.instance.collection("Recipients_Users").doc(recipient_email).set({
        "Name": recipient_name,
        "Email_Id": recipient_email,
        "Password": recipient_password,
        "Age": recipient_age,
        "Gender": recipient_gender,
        "Address": recipient_address
      }).then((value) {
        log("Signup Data Saved Successfully");
      }).catchError((error) {
        log("Error saving data: $error");
      });
    }
  }

  // Google sign-in logic
  Future<User?> _googleSignInMethod() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // The user canceled the sign-in
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credentials
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      // Check if the user already exists in Firestore by their email
      bool userExists = await emailExists(user?.email ?? "");
      if (!userExists) {
        // If the user doesn't exist, add them to Firestore
        await FirebaseFirestore.instance.collection("Recipients_Users").doc(user?.email).set({
          "Email_Id": user?.email,
          "Display_Name": user?.displayName ?? "No Name",
          "Profile_Picture": user?.photoURL ?? "",
          "Created_At": FieldValue.serverTimestamp(),
        });
        log("User added to Firestore");
      }

      return user; // Return the user object after signing in
    } catch (error) {
      log("Error during Google sign-in: $error");
      return null;
    }
  }

  // Sign up the recipient
  Future<void> _signup() async {
    if (nameController.text.isEmpty ||
        ageController.text.isEmpty ||
        genderController.text.isEmpty ||
        addressController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }
    bool emailAlreadyExists = await emailExists(emailController.text);

    if (emailAlreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('This email is already taken. Please try another one.')),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('recipient_name', nameController.text);
    await prefs.setString('recipient_email', emailController.text);
    await prefs.setString('recipient_password', passwordController.text);
    await prefs.setString('recipient_age', ageController.text);
    await prefs.setString('recipient_gender', genderController.text);
    await prefs.setString('recipient_address', addressController.text);

    // Save data to Firebase
    addData(
      nameController.text,
      emailController.text,
      passwordController.text,
      ageController.text,
      genderController.text,
      addressController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Signup successful! You can now login.')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipient Registration Form"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                ))
                    .toList(),
                onChanged: (value) {
                  genderController.text = value!; // Set gender value
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Create Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Create Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _signup,
                child: Text('Signup'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  User? user = await _googleSignInMethod();
                  if (user != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Signed in with Google!')),
                    );
                    // Navigate to RecipientsHomePage after successful sign-in
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RecipientsHomePage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Google Sign-In failed')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: BorderSide(color: Colors.grey, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/google.png', // Your uploaded image
                      height: 24,
                      width: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Register with Google',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
