import 'package:flutter/material.dart';
import 'package:my_first_app/Recipients/Recipients_Home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Import DonorSignUpPage to access stored donor data

class RecipientLoginPage extends StatefulWidget {
  @override
  _RecipientLoginPageState createState() => _RecipientLoginPageState();
}

class _RecipientLoginPageState extends State<RecipientLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? donorEmail = prefs.getString('email'); // Donor email
    String? donorPassword = prefs.getString('password'); // Donor password
    String? recipientEmail = prefs.getString('recipient_email'); // Recipient email
    String? recipientPassword = prefs.getString('recipient_password'); // Recipient password

    // Check if the email belongs to a donor account
    if ((donorEmail == emailController.text && donorPassword == passwordController.text) ||
        (recipientEmail == emailController.text && recipientPassword == passwordController.text)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RecipientsHomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email or password. Please try again or sign up.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipient Login Page"),
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
                    // Navigate to RecipientSignUpPage
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
