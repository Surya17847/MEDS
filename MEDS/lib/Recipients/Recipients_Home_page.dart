import 'package:flutter/material.dart';
import 'package:my_first_app/Recipients/Needy_Home_page.dart';
import 'package:my_first_app/Recipients/Buyer_Home_page.dart';

import '../home.dart';

class RecipientsHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Recipients Home Page',style: Theme.of(context).textTheme.headlineLarge,),
          //  leading: null,
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Buyer_Home_page()),
                  );
                },
                child: Text('Buyer'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Needy_Home_page()),
                  );
                },
                child: Text('Needy'),
              ),
            ],
          ),
        ));
  }
}
