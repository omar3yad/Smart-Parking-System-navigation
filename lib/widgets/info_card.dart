import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String floor;
  final String no;

  const InfoCard({super.key, required this.floor, required this.no});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.teal.withOpacity(0.12), blurRadius: 10, offset: const Offset(0,4)),
        ],
        border: Border.all(color: Colors.teal.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your chosen slot details :',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Floor  : ', style: TextStyle(fontWeight: FontWeight.w600)),
              Text(floor),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Text('No.   : ', style: TextStyle(fontWeight: FontWeight.w600)),
              Text(no),
            ],
          ),
        ],
      ),
    );
  }
}