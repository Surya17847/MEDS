import 'dart:io';
import 'package:flutter/material.dart';
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

  Future<void> _signup() async {
    // Check if any field is empty
    if (ngoNameController.text.isEmpty ||
        regNumberController.text.isEmpty ||
        contactPersonController.text.isEmpty ||
        contactNumberController.text.isEmpty ||
        emailController.text.isEmpty ||
        addressController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        _image == null) { // Check if image is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields and upload an image.')),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('ngo_name', ngoNameController.text);
    await prefs.setString('reg_number', regNumberController.text);
    await prefs.setString('contact_person', contactPersonController.text);
    await prefs.setString('contact_number', contactNumberController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('address', addressController.text);
    await prefs.setString('username', usernameController.text);
    await prefs.setString('password', passwordController.text);

    // Save the image path (for simplicity; in production, consider storing it securely)
    await prefs.setString('ngo_image', _image!.path);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Signup successful! You can now login.')),
    );

    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery); // Use pickImage instead of getImage

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
        title: Text("NGO Signup", style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: ngoNameController,
                decoration: InputDecoration(
                  labelText: 'NGO Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: regNumberController,
                decoration: InputDecoration(
                  labelText: 'Registration Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: contactPersonController,
                decoration: InputDecoration(
                  labelText: 'Contact Person',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: contactNumberController,
                decoration: InputDecoration(
                  labelText: 'Contact Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
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
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
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
              SizedBox(height: 20),
              // Image upload section
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
              // Show selected image (if any)
              if (_image != null) Image.file(_image!, height: 100),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _signup,
                child: Text('Signup'),
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
