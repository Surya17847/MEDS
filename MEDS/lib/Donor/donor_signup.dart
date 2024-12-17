import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_first_app/Donor/donor_after_login.dart';

class DonorSignUpPage extends StatefulWidget {
  @override
  _DonorSignUpPageState createState() => _DonorSignUpPageState();
}

class _DonorSignUpPageState extends State<DonorSignUpPage> {
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
          .collection("Donors_Users")
          .where("Email_Id", isEqualTo: email)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      log("Error checking email: $e");
      return false;
    }
  }

  // Add data to Firebase
  Future<void> addData(String donorName, String donorEmail, String donorPassword,
      String donorAge, String donorGender, String donorAddress) async {
    if (donorName.isEmpty ||
        donorEmail.isEmpty ||
        donorPassword.isEmpty ||
        donorAge.isEmpty ||
        donorGender.isEmpty ||
        donorAddress.isEmpty) {
      log("Enter required fields");
    } else {
      FirebaseFirestore.instance
          .collection("Donors_Users")
          .doc(donorEmail)
          .set({
        "Name": donorName,
        "Email_Id": donorEmail,
        "Password": donorPassword,
        "Age": donorAge,
        "Gender": donorGender,
        "Address": donorAddress
      }).then((value) {
        log("Donor data saved successfully");
      }).catchError((error) {
        log("Error saving donor data: $error");
      });
    }
  }

  // Google sign-in logic
  Future<User?> _googleSignInMethod() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // User canceled the sign-in
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      // Check if the user already exists in Firestore
      bool userExists = await emailExists(user?.email ?? "");
      if (!userExists) {
        await FirebaseFirestore.instance.collection("Donors_Users").doc(user?.email).set({
          "Email_Id": user?.email,
          "Display_Name": user?.displayName ?? "No Name",
          "Profile_Picture": user?.photoURL ?? "",
          "Created_At": FieldValue.serverTimestamp(),
        });
        log("User added to Firestore");
      }

      return user;
    } catch (error) {
      log("Error during Google sign-in: $error");
      return null;
    }
  }

  // Sign up the donor
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
    await prefs.setString('donor_name', nameController.text);
    await prefs.setString('donor_email', emailController.text);
    await prefs.setString('donor_password', passwordController.text);
    await prefs.setString('donor_age', ageController.text);
    await prefs.setString('donor_gender', genderController.text);
    await prefs.setString('donor_address', addressController.text);

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
        title: Text("Donor Registration Form"),
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
                  genderController.text = value!;
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => DonorOptionsPage()),
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
                      'assets/images/google.png',
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
