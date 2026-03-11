import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DurationSlider extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged; // هنبعت القيمة للـ parent

  const DurationSlider({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<DurationSlider> createState() => _DurationSliderState();
}

class _DurationSliderState extends State<DurationSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Duration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Text('${_currentValue.round()} h', style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: _currentValue,
            min: 1,
            max: 12,
            divisions: 11,
            label: '${_currentValue.round()} h',
            activeColor: Colors.teal,
            inactiveColor: Colors.grey,
            onChanged: (v) {
              setState(() {
                _currentValue = v;
              });
              widget.onChanged(v.round());
            },
          ),
        ],
      ),
    );
  }
}
