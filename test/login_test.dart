import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tusgo_v2/screens/auth/login_screen.dart';
import 'package:tusgo_v2/screens/customer/home_screen.dart';
import 'package:tusgo_v2/screens/provider/provider_dashboard.dart';
import 'package:tusgo_v2/screens/admin/admin_dashboard.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Тестийн дэлгэцийн хэмжээ
  setUp(() {
    // Өргөн дэлгэц ашиглаж overflow-оос сэргийлнэ
  });

  Future<void> openLogin(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
  }

  tearDown(() {
    // Дэлгэцийн хэмжээ тест бүрийн дараа сэргээгдэнэ
  });

  group('TusGo Login Tests', () {
    testWidgets('Login screen opens', (tester) async {
      await openLogin(tester);

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('Customer'), findsOneWidget);
      expect(find.text('Provider'), findsOneWidget);
      expect(find.text('Admin'), findsOneWidget);
    });

    testWidgets('Empty form shows validation errors', (tester) async {
      await openLogin(tester);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Нэвтрэх'));
      await tester.pump();

      expect(find.text('Зөв и-мэйл оруулна уу'), findsOneWidget);
      expect(
        find.text('Нууц үг хамгийн багадаа 6 тэмдэгт байна'),
        findsOneWidget,
      );
    });

    testWidgets('Invalid email is rejected', (tester) async {
      await openLogin(tester);

      final fields = find.byType(TextFormField);

      await tester.enterText(fields.at(0), 'invalid-email');
      await tester.enterText(fields.at(1), '123456');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Нэвтрэх'));
      await tester.pump();

      expect(find.text('Зөв и-мэйл оруулна уу'), findsOneWidget);
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('Short password is rejected', (tester) async {
      await openLogin(tester);

      final fields = find.byType(TextFormField);

      await tester.enterText(fields.at(0), 'test@example.com');
      await tester.enterText(fields.at(1), '123');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Нэвтрэх'));
      await tester.pump();

      expect(
        find.text('Нууц үг хамгийн багадаа 6 тэмдэгт байна'),
        findsOneWidget,
      );
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('Customer login opens HomeScreen', (tester) async {
      await openLogin(tester);

      final fields = find.byType(TextFormField);

      await tester.enterText(fields.at(0), 'customer@test.com');
      await tester.enterText(fields.at(1), '123456');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Нэвтрэх'));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
    });

    testWidgets('Provider login opens dashboard', (tester) async {
      await openLogin(tester);

      await tester.tap(find.text('Provider'));
      await tester.pump();

      final fields = find.byType(TextFormField);

      await tester.enterText(fields.at(0), 'provider@test.com');
      await tester.enterText(fields.at(1), '123456');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Нэвтрэх'));
      await tester.pumpAndSettle();

      expect(find.byType(ProviderDashboard), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
    });

    testWidgets('Admin login opens dashboard', (tester) async {
      await openLogin(tester);

      await tester.tap(find.text('Admin'));
      await tester.pump();

      final fields = find.byType(TextFormField);

      await tester.enterText(fields.at(0), 'admin@test.com');
      await tester.enterText(fields.at(1), '123456');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Нэвтрэх'));
      await tester.pumpAndSettle();

      expect(find.byType(AdminDashboard), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
    });
  });
}
