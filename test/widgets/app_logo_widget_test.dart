import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:sprints_shop/widgets/app_logo_widget.dart';

void main() {
  group('AppLogoWidget Tests', () {
    testWidgets('AppLogoWidget displays correctly with fallback', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: const AppLogoWidget.medium())),
      );

      // Check that the widget is displayed
      expect(find.byType(AppLogoWidget), findsOneWidget);
      expect(find.text('Sprints Shop'), findsOneWidget);

      // Since the asset might not load, the fallback should be visible
      await tester.pumpAndSettle();

      // Check that either the image or fallback container is present
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsAtLeastNWidgets(1));
    });

    testWidgets('AppLogoWidget.small displays without text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: const AppLogoWidget.small())),
      );

      expect(find.byType(AppLogoWidget), findsOneWidget);
      expect(find.text('Sprints Shop'), findsNothing);
    });

    testWidgets('AnimatedAppLogo displays with animation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedAppLogo(
              logo: const AppLogoWidget.large(),
              autoStart: false,
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedAppLogo), findsOneWidget);
      expect(find.byType(AppLogoWidget), findsOneWidget);

      await tester.pumpAndSettle();
    });
  });
}
