import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/service_item.dart';

class MockServices extends ChangeNotifier {
  MockServices._();

  static final MockServices instance = MockServices._();

  static const String _storageKey = 'tusgo_services_v1';

  // Admin идэвхгүй болгосон үйлчилгээний ID-нууд
  final Set<String> _disabledIds = {};

  // Local Storage-оос үйлчилгээний тохиргоог сэргээх
  Future<void> loadServices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString(_storageKey);

      // Анх удаа ажиллаж байвал бүх үйлчилгээ идэвхтэй
      if (savedData == null) {
        return;
      }

      final decoded = jsonDecode(savedData) as List<dynamic>;

      _disabledIds
        ..clear()
        ..addAll(decoded.cast<String>());

      notifyListeners();
    } catch (error) {
      debugPrint('Үйлчилгээний тохиргоо сэргээхэд алдаа гарлаа: $error');
    }
  }

  // Идэвхгүй үйлчилгээний ID-нуудыг хадгалах
  Future<void> saveServices() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final encoded = jsonEncode(_disabledIds.toList());

      final success = await prefs.setString(_storageKey, encoded);

      if (!success) {
        debugPrint('Үйлчилгээний тохиргоог хадгалж чадсангүй.');
      }
    } catch (error) {
      debugPrint('Үйлчилгээний тохиргоо хадгалахад алдаа гарлаа: $error');
    }
  }

  // UI-г шинэчилж, өгөгдлийг хадгалах
  void _notifyAndSave() {
    notifyListeners();
    saveServices();
  }

  // Үйлчилгээ идэвхтэй эсэх
  bool isActive(String serviceId) {
    return !_disabledIds.contains(serviceId);
  }

  // Идэвхтэй үйлчилгээний жагсаалт
  List<ServiceItem> get activeServices {
    return services.where((service) {
      return isActive(service.id);
    }).toList();
  }

  // Идэвхтэй үйлчилгээний тоо
  int get activeCount => activeServices.length;

  // Admin үйлчилгээ идэвхжүүлэх / идэвхгүй болгох
  void setActive(String serviceId, bool active) {
    if (active) {
      _disabledIds.remove(serviceId);
    } else {
      _disabledIds.add(serviceId);
    }

    _notifyAndSave();
  }
}
