import 'package:flutter/material.dart';

class CheckDonationStatusPage extends StatelessWidget {
  final List<DonationStatus> donationStatuses = [
    DonationStatus(
      medicineName: 'Paracetamol',
      status: 'Delivered',
      date: '2023-09-20',
    ),
    DonationStatus(
      medicineName: 'Ibuprofen',
      status: 'Pending',
      date: '2023-09-22',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Donation Status',style: Theme.of(context).textTheme.headlineLarge,),
 backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: donationStatuses.length,
        itemBuilder: (context, index) {
          return DonationStatusCard(
            medicineName: donationStatuses[index].medicineName,
            status: donationStatuses[index].status,
            date: donationStatuses[index].date,
          );
        },
      ),
    );
  }
}

class DonationStatusCard extends StatelessWidget {
  final String medicineName;
  final String status;
  final String date;

  DonationStatusCard({required this.medicineName, required this.status, required this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text('$medicineName'),
        subtitle: Text('Status: $status\nDate: $date'),
      ),
    );
  }
}

class DonationStatus {
  final String medicineName;
  final String status;
  final String date;

  DonationStatus({required this.medicineName, required this.status, required this.date});
}
