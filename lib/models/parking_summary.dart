class ParkingSummary {
  final int totalSlots;
  final int available;
  final int occupied;
  final int reserved;

  ParkingSummary({
    required this.totalSlots,
    required this.available,
    required this.occupied,
    required this.reserved,
  });

  factory ParkingSummary.fromJson(Map<String, dynamic> json) {
    return ParkingSummary(
      totalSlots: json['total_slots'] as int? ?? 0,
      available: json['available'] as int? ?? 0,
      occupied: json['occupied'] as int? ?? 0,
      reserved: json['reserved'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'total_slots': totalSlots,
      'available': available,
      'occupied': occupied,
      'reserved': reserved,
    };
  }
}

