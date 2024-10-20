import 'package:flutter/material.dart';

class NGOActionConfirmationPage extends StatelessWidget {
  final bool isApproved; // This will determine if it's approval or rejection

  // Constructor to pass the action type (approve or reject)
  NGOActionConfirmationPage({required this.isApproved});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isApproved ? 'Medicine Approved' : 'Medicine Rejected'),
        backgroundColor: isApproved ? Colors.green : Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isApproved ? Icons.check_circle_outline : Icons.cancel_outlined,
              size: 100,
              color: isApproved ? Colors.green : Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              isApproved
                  ? 'You have successfully approved the donation.'
                  : 'You have rejected the donation request.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the main dashboard or medicine listing page
                Navigator.pop(context);
              },
              child: Text('Go back to Dashboard'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
