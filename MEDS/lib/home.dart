// home.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_first_app/Donor/donor_login.dart';
import 'package:my_first_app/Donor/donor_signup.dart';
import 'package:my_first_app/Recipients/recipients_signup.dart';

import 'NGO/NGO_login.dart';
import 'NGO/ngo_signup.dart';
import 'Recipients/recipients_login.dart';
import 'package:my_first_app/phoneOTP.dart'; // Import the PhoneAuth screen

class EntryTypeSelection extends StatefulWidget {
  @override
  State<EntryTypeSelection> createState() => _EntryTypeSelectionState();
}

class _EntryTypeSelectionState extends State<EntryTypeSelection> {
  String? selectedType; // Track the selected button type
  bool showProceedButtons = false; // Flag to control the visibility of Login/Signup buttons
  bool isBiometricEnabled = false; // Track if biometric authentication is enabled

  @override
  void initState() {
    super.initState();
    _loadBiometricPreference(); // Load biometric preference on init
  }

  // Load the biometric preference from shared preferences
  Future<void> _loadBiometricPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isBiometricEnabled = prefs.getBool('biometric_enabled') ?? false;
    });
  }

  // Toggle biometric preference and save to shared preferences
  Future<void> _toggleBiometric(bool? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isBiometricEnabled = value ?? false;
    });
    await prefs.setBool('biometric_enabled', isBiometricEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome to MEDS",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image at the center above the text
              Center(
                child: Image.asset(
                  'assets/images/meds_icon.png', // Path to your image
                  height: 150, // Set the height as needed
                  width: 150, // Set the width as needed
                ),
              ),
              SizedBox(height: 20), // Space between image and text
              Text(
                'Enter As:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 25),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Recipients Button
                  ElevatedButton(
                    child: Text("Recipients"),
                    onPressed: () {
                      setState(() {
                        selectedType = "Recipients"; // Set selected type to Recipients
                        showProceedButtons = false; // Hide proceed buttons until 'Proceed' is pressed
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedType == "Recipients"
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white, // Change color based on selected state
                      foregroundColor: selectedType == "Recipients"
                          ? Colors.white
                          : Colors.black, // Text color
                    ),
                  ),

                  // NGO Button
                  ElevatedButton(
                    child: Text("NGO"),
                    onPressed: () {
                      setState(() {
                        selectedType = "NGO"; // Set selected type to NGO
                        showProceedButtons = false; // Hide proceed buttons until 'Proceed' is pressed
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedType == "NGO"
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white, // Change color based on selected state
                      foregroundColor: selectedType == "NGO"
                          ? Colors.white
                          : Colors.black, // Text color
                    ),
                  ),

                  // Donor Button
                  ElevatedButton(
                    child: Text("Donor"),
                    onPressed: () {
                      setState(() {
                        selectedType = "Donor"; // Set selected type to Donor
                        showProceedButtons = false; // Hide proceed buttons until 'Proceed' is pressed
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedType == "Donor"
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white, // Change color based on selected state
                      foregroundColor: selectedType == "Donor"
                          ? Colors.white
                          : Colors.black, // Text color
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Proceed Button
              ElevatedButton(
                child: Text("Proceed to Login/Signup"),
                onPressed: () {
                  if (selectedType != null) {
                    setState(() {
                      showProceedButtons = true; // Show Login/Signup buttons
                    });
                  } else {
                    // Show an error if no type is selected
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please select an entry type")),
                    );
                  }
                },
              ),
              SizedBox(height: 20),

              // Conditional display of Login/Signup buttons
              if (showProceedButtons)
                Column(
                  children: [
                    ElevatedButton(
                      child: Text("Login"),
                      onPressed: () {
                        if (selectedType == "Donor") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DonorLoginPage()),
                          );
                        } else if (selectedType == "Recipients") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RecipientLoginPage()),
                          );
                        } else if (selectedType == "NGO") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NGOLoginPage()),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      child: Text("SignUp"),
                      onPressed: () {
                        if (selectedType == "Donor") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DonorSignUpPage()),
                          );
                        } else if (selectedType == "Recipients") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RecipientSignUpPage()),
                          );
                        } else if (selectedType == "NGO") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NGOSignUpPage()),
                          );
                        }
                      },
                    ),
                  ],
                ),
              SizedBox(height: 7),

              // Mobile authentication option
              ElevatedButton(
                child: Text("Proceed with Mobile Authentication"),
                onPressed: () {
                  if (selectedType != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhoneAuth(
                          selectedType: selectedType!, // Pass the selected type here
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please select an entry type")),
                    );
                  }
                },
              ),

              // Biometric toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Enable Biometric Authentication"),
                  Container(
                    child: Switch(
                      value: isBiometricEnabled,
                      onChanged: _toggleBiometric,
                      activeColor: Colors.green, // Color when the switch is active
                      inactiveThumbColor: Colors.grey, // Color for the thumb when inactive
                      inactiveTrackColor: Colors.grey[300], // Color for the track when inactive
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
