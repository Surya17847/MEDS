import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class NGOSignUpPage extends StatefulWidget {
  @override
  _NGOSignUpPageState createState() => _NGOSignUpPageState();
}

class _NGOSignUpPageState extends State<NGOSignUpPage> {
  final TextEditingController ngoNameController = TextEditingController();
  final TextEditingController regNumberController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  File? _image; // To store the selected image file
  bool _isUploading = false;

  Future<void> _signup() async {
    if (ngoNameController.text.isEmpty ||
        regNumberController.text.isEmpty ||
        contactPersonController.text.isEmpty ||
        contactNumberController.text.isEmpty ||
        emailController.text.isEmpty ||
        addressController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and upload an image.')),
      );
      return;
    }

    setState(() {
      _isUploading = true; // Show loading indicator
    });

    try {
      // Upload image to Firebase Storage
      String imageURL = await _uploadImageToFirebase();

      // Save NGO data to Firestore
      await FirebaseFirestore.instance
          .collection('NGO_Users')
          .doc(emailController.text) // Use email as the document ID
          .set({
        'NGO_Name': ngoNameController.text,
        'Registration_Number': regNumberController.text,
        'Contact_Person': contactPersonController.text,
        'Contact_Number': contactNumberController.text,
        'Email': emailController.text,
        'Address': addressController.text,
        'Username': usernameController.text,
        'Password': passwordController.text,
        'NGO_Image_URL': imageURL,
      });

      // Save credentials locally in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('ngo_email', emailController.text);
      await prefs.setString('ngo_password', passwordController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup successful!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false; // Hide loading indicator
      });
    }
  }

  // Function to upload image to Firebase Storage
  Future<String> _uploadImageToFirebase() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('ngo_certificates/${emailController.text}.jpg');
    await storageRef.putFile(_image!); // Upload the image file
    return await storageRef.getDownloadURL(); // Get the download URL
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No image selected.')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NGO Signup"),
      ),
      body: _isUploading
          ? Center(child: CircularProgressIndicator()) // Show loader when uploading
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildTextField(ngoNameController, "NGO Name"),
              _buildTextField(regNumberController, "Registration Number"),
              _buildTextField(contactPersonController, "Contact Person"),
              _buildTextField(contactNumberController, "Contact Number",
                  inputType: TextInputType.phone),
              _buildTextField(emailController, "Email",
                  inputType: TextInputType.emailAddress),
              _buildTextField(addressController, "Address"),
              _buildTextField(usernameController, "Username"),
              _buildTextField(passwordController, "Password",
                  obscureText: true),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Upload NGO Certificate/ID'),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Choose Image'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              if (_image != null) Image.file(_image!, height: 100),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _signup,
                child: Text('Signup'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      horizontal: 50, vertical: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build text fields
  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType inputType = TextInputType.text, bool obscureText = false}) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
          keyboardType: inputType,
          obscureText: obscureText,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
