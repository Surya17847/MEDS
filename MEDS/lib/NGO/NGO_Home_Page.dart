import 'package:flutter/material.dart';
import 'package:my_first_app/NGO/Request_donated_medicine.dart';
import 'package:my_first_app/NGO/check_donation_status.dart';
import 'package:my_first_app/NGO/view_donated_medicine.dart';

import '../home.dart';

class NGODashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NGO Dashboard',style: Theme.of(context).textTheme.headlineLarge,),
                  automaticallyImplyLeading: false, 

 backgroundColor: Theme.of(context).colorScheme.primary,
  actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => EntryTypeSelection()), // Replace RecipientsHomePage with the actual class for that page
      (Route<dynamic> route) => false, // This will clear all the previous routes
    );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Welcome to the NGO Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // View Donated Medicines
            ElevatedButton(
              onPressed: () {
                // Navigate to the View Donated Medicines Page
               Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewDonatedMedicinesPage(),
                  ),
                );
              },
              child: Text('View Donated Medicines'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            // Request for Medicines
            ElevatedButton(
              onPressed: () {
                // Navigate to the Request for Medicines Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestForMedicinesPage(),
                  ),
                );
              },
              child: Text('Request for Medicines'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            // Check Donation Status
            ElevatedButton(
              onPressed: () {
                // Navigate to the Check Donation Status Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckDonationStatusPage(),
                  ),
                );
              },
              child: Text('Check Donation Status'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            // Other actions (e.g., Logout)
            // ElevatedButton(
            //   onPressed: () {
            //     // Perform logout
            //     Navigator.of(context).pop();
            //   },
            //   child: Text('Logout'),
            //   style: ElevatedButton.styleFrom(
            //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// // Placeholder Pages for Navigation
// class ViewDonatedMedicinesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Donated Medicines')),
//       body: Center(child: Text('List of Donated Medicines will be shown here')),
//     );
//   }
// }

// class RequestForMedicinesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Request for Medicines')),
//       body: Center(child: Text('Request Medicines Page')),
//     );
//   }
// }

// class CheckDonationStatusPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Donation Status')),
//       body: Center(child: Text('Check Donation Status Page')),
//     );
//   }
// }
