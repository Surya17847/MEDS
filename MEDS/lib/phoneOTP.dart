import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_first_app/otpScr.dart'; // Make sure to import the OTP screen

class PhoneAuth extends StatefulWidget {
  final String selectedType;

  // Constructor now properly accepts selectedType
  const PhoneAuth({super.key, required this.selectedType});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meds Phone Authentication"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Enter Phone Number",
                suffixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              try {
                // Initiating phone number verification process
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: phoneController.text.trim(),
                  verificationCompleted: (PhoneAuthCredential credential) {
                    // Handle automatic code verification (e.g., on-device)
                  },
                  verificationFailed: (FirebaseAuthException ex) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Verification failed: ${ex.message}")),
                    );
                  },
                  codeSent: (String verificationId, int? resendToken) {
                    // After the OTP is sent, navigate to the OTP screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Otpscr(
                          verificationid: verificationId,
                          selectedType: widget.selectedType, // Pass the selectedType here
                        ),
                      ),
                    );
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {
                    // Handle timeout if needed
                  },
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
            child: Text("Verify Phone Number"),
          ),
        ],
      ),
    );
  }
}
