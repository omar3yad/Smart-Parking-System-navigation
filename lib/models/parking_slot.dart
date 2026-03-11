class ParkingSlot {
  final String slotId;
  final String slotNumber;
  final String status;
  final String slotType;
  final int floor;

  ParkingSlot({
    required this.slotId,
    required this.slotNumber,
    required this.status,
    required this.slotType,
    required this.floor,
  });

  factory ParkingSlot.fromJson(Map<String, dynamic> json) {
    return ParkingSlot(
      slotId: json['slot_id']?.toString() ?? '',
      slotNumber: json['slot_number']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      slotType: json['slot_type']?.toString() ?? '',
      floor: (json['floor'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'slot_id': slotId,
      'slot_number': slotNumber,
      'status': status,
      'slot_type': slotType,
      'floor': floor,
    };
  }
}
