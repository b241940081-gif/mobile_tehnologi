import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tusgo_v2/main.dart';
import 'package:tusgo_v2/screens/welcome/welcome_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('TusGo welcome screen test', (WidgetTester tester) async {
    // Аппыг ажиллуулах
    await tester.pumpWidget(const TusGoApp());

    // MaterialApp үүссэн эсэх
    expect(find.byType(MaterialApp), findsOneWidget);

    // Эхлэх дэлгэц зөв нээгдсэн эсэх
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });
}
