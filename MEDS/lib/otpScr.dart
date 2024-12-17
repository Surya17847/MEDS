// otpscr.dart

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/Donor/donor_login.dart';
import 'package:my_first_app/Donor/donor_signup.dart';
import 'package:my_first_app/Recipients/recipients_login.dart';
import 'package:my_first_app/NGO/NGO_login.dart';

class Otpscr extends StatefulWidget {
  final String verificationid;
  final String selectedType; // Accept selectedType

  Otpscr({super.key, required this.verificationid, required this.selectedType});

  @override
  State<Otpscr> createState() => _OtpscrState();
}

class _OtpscrState extends State<Otpscr> {
  TextEditingController otpController = TextEditingController();

  void submitOtp() async {
    String enteredOtp = otpController.text;
    if (enteredOtp.isNotEmpty) {
      try {
        // Use PhoneAuthProvider.credential directly from the class
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationid,
          smsCode: otpController.text.trim(),
        );

        // Sign in using the generated credential
        await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
          // Navigate to the correct login screen based on selectedType
          if (widget.selectedType == "Donor") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DonorLoginPage()));
          } else if (widget.selectedType == "Recipients") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RecipientLoginPage()));
          } else if (widget.selectedType == "NGO") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NGOLoginPage()));
          }
        });
      } catch (ex) {
        log(ex.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error during OTP verification: $ex")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter the OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Screen"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter the OTP",
                suffixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: submitOtp,
              child: Text("Submit OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
