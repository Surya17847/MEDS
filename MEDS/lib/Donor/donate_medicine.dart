import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_first_app/Donor/donor_after_login.dart';

class DonateMedicinePage extends StatefulWidget {
  @override
  State<DonateMedicinePage> createState() => _DonateMedicinePageState();
}

class _DonateMedicinePageState extends State<DonateMedicinePage> {
  String? Medicine_Image;
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _strengthController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _expirationDateController = TextEditingController();
  final TextEditingController _manufacturerController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Image Picker
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        Medicine_Image = image.path; // Save the selected image path
      });
    }
  }

  DateTime? _selectedDate;

  Future<void> _pickExpirationDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Prevent picking past dates
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _expirationDateController.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format: YYYY-MM-DD
      });
    }
  }


  // Submit donation to Firestore
  Future<void> _submitDonation() async {
    try {
      // Assuming user collection is named 'Donors_Users'
      final firestore = FirebaseFirestore.instance;

      // Fetch the current donor's document (replace hardcoded email with logged-in user logic if needed)
      final donorDocRef = firestore.collection('Donors_Users').doc('harshpatil@gmail.com');
      final donorSnapshot = await donorDocRef.get();

      if (!donorSnapshot.exists) {
        throw Exception("Donor data not found in Firestore. Please log in again.");
      }

      // Fetch the donor's donation count
      int donationCount = 0;
      if (donorSnapshot.data()!.containsKey('donationCount')) {
        donationCount = donorSnapshot.data()!['donationCount'] as int;
      }

      // Increment the donation count
      donationCount++;

      // Save the new donation as a subcollection under donor's document
      final medicineData = {
        'MedicineName': _medicineNameController.text,
        'Strength': _strengthController.text,
        'Quantity': _quantityController.text,
        'ExpirationDate': _expirationDateController.text,
        'Manufacturer': _manufacturerController.text,
        'Notes': _notesController.text,
        'ImagePath': Medicine_Image ?? '',
        'DonationDate': DateTime.now().toIso8601String(),
      };

      // Add the medicine data to a "Medicine" subcollection
      await donorDocRef.collection('Medicine').doc('Dn_no_$donationCount').set(medicineData);

      // Update the donation count in the main donor document
      await donorDocRef.set({'donationCount': donationCount}, SetOptions(merge: true));

      // Navigate to confirmation page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DonationConfirmationPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: ${e.toString()}"),
        backgroundColor: Colors.red,
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donate Medicines',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _medicineNameController,
                decoration: InputDecoration(
                  labelText: 'Medicine Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _strengthController,
                decoration: InputDecoration(
                  labelText: 'Strength (e.g., 500 mg)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity Available',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _expirationDateController,
                readOnly: true, // Prevent manual input
                decoration: InputDecoration(
                  labelText: 'Expiration Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _pickExpirationDate, // Show date picker
                  ),
                ),
              ),

              SizedBox(height: 20),
              TextField(
                controller: _manufacturerController,
                decoration: InputDecoration(
                  labelText: 'Manufacturer',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Additional Notes (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Medicine_Image == null
                    ? Center(child: Text('No image selected'))
                    : Image.file(
                  File(Medicine_Image!), // Display the selected image
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Upload Image'),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitDonation,
                child: Text('Submit Donation'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DonationConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Confirmation Page",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            color: Colors.greenAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    child: Text(
                      "Thanks For Donating to us!",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DonorOptionsPage()),
                    );
                  },
                  child: Text("Back"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
