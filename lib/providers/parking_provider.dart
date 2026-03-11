import 'package:flutter/foundation.dart';
import '../models/parking_slot.dart';
import '../models/parking_summary.dart';
import '../repositories/parking_repository.dart';

class ParkingProvider extends ChangeNotifier {
  ParkingProvider(this._parkingRepository) {
    loadSummary();
    loadSlots(floor: '0'); // التحميل الافتراضي للدور الأرضي
  }

  final ParkingRepository _parkingRepository;

  ParkingSummary? _summary;
  bool _isSummaryLoading = false;

  List<ParkingSlot> _slots = <ParkingSlot>[];
  bool _isSlotsLoading = false;

  String _selectedFloor = '0'; // '0' للجراوند، '1' للدور الأول، '2' للثاني
  String? _selectedSlotId;

  // Getters
  ParkingSummary? get summary => _summary;
  bool get isSummaryLoading => _isSummaryLoading;
  List<ParkingSlot> get slots => _slots;
  bool get isSlotsLoading => _isSlotsLoading;
  String get selectedFloor => _selectedFloor;
  String? get selectedSlotId => _selectedSlotId;

  // تغيير الدور وتحميل بياناته
  void setFloor(String floor) {
    _selectedFloor = floor;
    _selectedSlotId = null; // مسح الاختيار عند تغيير الدور
    loadSlots(floor: floor);
    notifyListeners();
  }

  Future<void> loadSummary() async {
    _isSummaryLoading = true;
    notifyListeners();
    try {
      _summary = await _parkingRepository.fetchSummary();
    } catch (e) {
      if (kDebugMode) print('Summary Error: $e');
    } finally {
      _isSummaryLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSlots({String? floor}) async {
    _isSlotsLoading = true;
    notifyListeners();
    try {
      // نرسل الدور للـ API (تأكدي أن الـ Repository يدعم معامل floor)
      _slots = await _parkingRepository.fetchSlots(floor: floor ?? _selectedFloor);
    } catch (e) {
      if (kDebugMode) print('Slots Error: $e');
    } finally {
      _isSlotsLoading = false;
      notifyListeners();
    }
  }

  void selectSlot(String slotId) {
    if (_selectedSlotId == slotId) {
      _selectedSlotId = null;
    } else {
      _selectedSlotId = slotId; // هنا يتم اختيار ID واحد فقط
    }
    notifyListeners();
  }
}