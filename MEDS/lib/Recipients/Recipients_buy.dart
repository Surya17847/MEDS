import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ConfirmOrderPage_Buyer extends StatefulWidget {
  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage_Buyer> {
  String? prescriptionImage; // Store the image path
  String selectedPaymentMethod = 'Debit Card'; // Default payment method
  Razorpay razorpay=Razorpay();
  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        prescriptionImage = image.path; // Save the selected image path
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Order',style: Theme.of(context).textTheme.headlineLarge,),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Please review your order details:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            
            // Text about uploading prescription image
            Text(
              'Upload Image of Prescription:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),

            // Container to display the uploaded image
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: prescriptionImage == null
                  ? Center(child: Text('No image selected'))
                  : Image.file(
                      File(prescriptionImage!), // Display the selected image
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(height: 10),
            
            // Button to select image
            ElevatedButton(
                onPressed: _pickImage,
                child: Text('Upload Image'),
              ),
          
            SizedBox(height: 20),
            
            // Confirm Order button
           ElevatedButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>BuyerInformationPage()));
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text('Proceed for Payement>>')),
                  // );

                  var options = {
  'key': 'rzp_test_GcZZFDPP0jHtC4',
  'amount': 1000,
  'name': 'Medicine order',
  'description': 'Easy Redistribution',
  'prefill': {
    'contact': '8888888888',
    'email': 'test@razorpay.com'
  }
};
razorpay.open(options);
                },
                child: Text('Proceed for Payement >>'),
              ),
            
          ],
        ),
      ),
    );
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
  // Do something when payment succeeds
  Fluttertoast.showToast(msg:"Payement Success!!");
}

void _handlePaymentError(PaymentFailureResponse response) {
  // Do something when payment fails
    Fluttertoast.showToast(msg:"Payement Failed!!");

}
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    try{
    razorpay.clear(); 
    }
    catch(e)// Removes all listeners
  {
    print(e);
  }

}

}
