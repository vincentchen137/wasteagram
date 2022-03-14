import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wasteagram/main.dart' as app;


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("testing UX flow", () {
    testWidgets("testing List Screen to Detail Post and back to List Screen", (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Create finder for Camera Button
        final recentPost = find.byType(ListTile).first;
        expect(recentPost, findsOneWidget);
      
        await tester.tap(recentPost);
        await tester.pumpAndSettle();

        final backButton = find.byType(BackButton).first;
        expect(backButton, findsOneWidget);

        // Wait for 2 seconds to slow down animation
        await Future.delayed(const Duration(seconds: 3), () {});

        await tester.tap(backButton);
        await tester.pumpAndSettle();
      });
  });
}