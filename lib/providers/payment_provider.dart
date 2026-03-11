import 'package:flutter/material.dart';

class PaymentProvider extends ChangeNotifier {
  double pricePerHour = 20.0; // You can change it

  double totalPriceForHours(int hours) => hours * pricePerHour;

  
  Future<void> processPayment(Map<String, dynamic> data) async {
    // هنا هتبعتي البيانات للباك اند
    // مثال:
    // final response = await http.post(Uri.parse("YOUR_API_URL"),
    //     body: jsonEncode(data),
    //     headers: {"Content-Type": "application/json"});

    print("Payment data sent: $data");
  }
}
