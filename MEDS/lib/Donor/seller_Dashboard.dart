import 'package:flutter/material.dart';
import 'package:my_first_app/Donor/sell_medicines.dart';

class seller_Dashboard extends StatelessWidget {
  final List<Map<String, dynamic>> medicines = [
    {
      'name': 'Paracetamol',
      'dosageForm': 'Tablet',
      'strength': '500mg',
      'quantityAvailable': 10,
      'expiryDate': '2025-12-01',
      'manufacturer': 'ABC Pharmaceuticals',
      'image': 'Paracetamol.jpeg',
    },
    {
      'name': 'Ibuprofen',
      'dosageForm': 'Tablet',
      'strength': '200mg',
      'quantityAvailable': 15,
      'expiryDate': '2024-06-15',
      'manufacturer': 'XYZ Pharmaceuticals',
      'image': 'Ibuprofen.jpeg',
    },
    // Add more medicines here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi!, User', style: Theme.of(context).textTheme.headlineLarge),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search Medicines',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: medicines.length + 1, // One extra for the icon button
              itemBuilder: (context, index) {
                if (index == medicines.length) {
                  // This is the icon below the list
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        Center(
                          child:  FloatingActionButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SellMedicinePage()));
                                },
                                child: Icon(Icons.add), // Plus icon
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                
                              ),
                            
                            
                        ),
                         Text(
                    "Need to add new medicines to your list?",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Simply tap the '+' button to quickly add and manage your medicine stock. Ensure that you regularly update expired medicines.",
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                      ],
                    ),
                    

                  );
                }
                final medicine = medicines[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/${medicine["image"]}',
                          width: 50,
                          height: 50,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                medicine['name']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Manufacturer: ${medicine['manufacturer']}'),
                              Text('Expiry Date: ${medicine['expiryDate']}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
