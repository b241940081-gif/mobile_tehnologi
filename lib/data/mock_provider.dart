import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockProvider extends ChangeNotifier {
  MockProvider._();

  static final MockProvider instance = MockProvider._();

  static const String _storageKey = 'tusgo_provider_v1';

  // Provider-ийн үндсэн мэдээлэл
  String name = 'TusGo Demo Provider';
  String phone = '99112233';
  String description = 'Найдвартай, түргэн шуурхай үйлчилгээ.';

  // Provider-ийн сонгосон үйлчилгээнүүд
  final Set<String> selectedServiceIds = {'water'};

  // Local Storage-оос мэдээлэл сэргээх
  Future<void> loadProvider() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString(_storageKey);

      // Өмнө хадгалсан мэдээлэл байхгүй бол
      // анхны demo мэдээллийг ашиглана
      if (savedData == null) {
        await saveProvider();
        return;
      }

      final decoded = jsonDecode(savedData) as Map<String, dynamic>;

      name = decoded['name'] as String? ?? 'TusGo Demo Provider';

      phone = decoded['phone'] as String? ?? '99112233';

      description =
          decoded['description'] as String? ??
          'Найдвартай, түргэн шуурхай үйлчилгээ.';

      // Өмнөх сонголтуудыг цэвэрлээд сэргээнэ
      final savedServices =
          (decoded['selectedServiceIds'] as List<dynamic>?)?.cast<String>() ??
          ['water'];

      selectedServiceIds
        ..clear()
        ..addAll(savedServices);

      notifyListeners();
    } catch (error) {
      debugPrint('Provider мэдээлэл сэргээхэд алдаа гарлаа: $error');
    }
  }

  // Provider-ийн мэдээллийг хадгалах
  Future<void> saveProvider() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final data = {
        'name': name,
        'phone': phone,
        'description': description,
        'selectedServiceIds': selectedServiceIds.toList(),
      };

      final success = await prefs.setString(_storageKey, jsonEncode(data));

      if (!success) {
        debugPrint('Provider мэдээллийг хадгалж чадсангүй.');
      }
    } catch (error) {
      debugPrint('Provider мэдээлэл хадгалахад алдаа гарлаа: $error');
    }
  }

  // UI-г шинэчилж, өгөгдлийг хадгалах
  void _notifyAndSave() {
    notifyListeners();
    saveProvider();
  }

  // Provider тухайн үйлчилгээг үзүүлдэг эсэх
  bool provides(String serviceId) {
    return selectedServiceIds.contains(serviceId);
  }

  // Үйлчилгээ сонгох / сонголт болиулах
  void toggleService(String serviceId) {
    if (selectedServiceIds.contains(serviceId)) {
      selectedServiceIds.remove(serviceId);
    } else {
      selectedServiceIds.add(serviceId);
    }

    _notifyAndSave();
  }

  // Provider-ийн профайл шинэчлэх
  void updateProfile({
    required String newName,
    required String newPhone,
    required String newDescription,
  }) {
    name = newName;
    phone = newPhone;
    description = newDescription;

    _notifyAndSave();
  }
}
