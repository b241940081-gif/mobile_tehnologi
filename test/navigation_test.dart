import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tusgo_v2/main.dart';
import 'package:tusgo_v2/screens/welcome/welcome_screen.dart';
import 'package:tusgo_v2/screens/auth/login_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Welcome screen navigates to Login screen', (
    WidgetTester tester,
  ) async {
    // Тестийн дэлгэцийн хэмжээг тохируулах
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Аппыг ажиллуулах
    await tester.pumpWidget(const TusGoApp());

    // Welcome дэлгэц байгаа эсэх
    expect(find.byType(WelcomeScreen), findsOneWidget);

    // Эхлэх товчийг шалгах
    expect(find.text('Эхлэх'), findsOneWidget);

    // Эхлэх товч дарах
    await tester.tap(find.text('Эхлэх'));

    // Дэлгэцийн шилжилтийг гүйцээх
    await tester.pumpAndSettle();

    // Login дэлгэц нээгдсэн эсэх
    expect(find.byType(LoginScreen), findsOneWidget);

    // Welcome дэлгэц солигдсон эсэх
    expect(find.byType(WelcomeScreen), findsNothing);
  });
}
