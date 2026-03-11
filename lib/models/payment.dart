import 'package:flutter/material.dart';
class PaymentMethodModel {
  final String title;
  final IconData icon;
  bool isExpanded;

  PaymentMethodModel({
    required this.title,
    required this.icon,
    this.isExpanded = false,
  });
}
