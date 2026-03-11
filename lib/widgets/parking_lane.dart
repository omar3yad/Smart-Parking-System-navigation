import 'package:flutter/material.dart';

class ParkingLane extends StatelessWidget {
  final int arrowCount;

  const ParkingLane({super.key, required this.arrowCount});

  @override
  Widget build(BuildContext context) {
    // نفس عدد الأسهم = نفس عدد الصفوف،
    // وكل سهم في "صف" بنفس ارتفاع السلوت جنبُه تقريبًا.
    const double rowHeight = 62; // 50 ارتفاع السلوت + 12 padding تقريبًا

    return Container(
      width: 40,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: List.generate(
          arrowCount,
          (index) => const SizedBox(
            height: rowHeight,
            child: Center(
              child: Icon(
                Icons.arrow_downward,
                color: Color(0xFFFFB74D),
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}