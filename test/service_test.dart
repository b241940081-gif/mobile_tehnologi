import 'package:flutter_test/flutter_test.dart';
import 'package:tusgo_v2/data/mock_provider.dart';
import 'package:tusgo_v2/data/mock_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });
  group('TusGo Service Tests', () {
    test('Admin can disable and enable a service', () {
      final services = MockServices.instance;

      // Эхний төлөвийг хадгалах
      final wasActive = services.isActive('water');

      try {
        // Үйлчилгээг идэвхгүй болгох
        services.setActive('water', false);

        expect(services.isActive('water'), false);

        // Үйлчилгээг идэвхжүүлэх
        services.setActive('water', true);

        expect(services.isActive('water'), true);
      } finally {
        // Өмнөх төлөвт буцаах
        services.setActive('water', wasActive);
      }
    });

    test('Provider can select and deselect a service', () {
      final provider = MockProvider.instance;

      final wasSelected = provider.provides('water');

      try {
        // Сонголтыг өөрчлөх
        provider.toggleService('water');

        expect(provider.provides('water'), !wasSelected);

        // Буцааж өөрчлөх
        provider.toggleService('water');

        expect(provider.provides('water'), wasSelected);
      } finally {
        // Алдаа гарсан ч эхний төлөвийг сэргээх
        if (provider.provides('water') != wasSelected) {
          provider.toggleService('water');
        }
      }
    });
  });
}
