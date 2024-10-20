import 'package:flutter/material.dart';
import 'package:my_first_app/Donor/donor_Dashboard.dart';
import 'package:my_first_app/Donor/seller_Dashboard.dart';

import '../home.dart';

class DonorOptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Give medicines',style: Theme.of(context).textTheme.headlineLarge,),
 backgroundColor: Theme.of(context).colorScheme.primary,
 automaticallyImplyLeading: false,
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>donor_Dashboard()));
                },
                child: Text('Donate Medicines'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>seller_Dashboard()));
                },
                child: Text('Sell Medicines'),
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
