import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:untitled6/main.dart' as app;

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
            (tester) async {
          app.main();
          await tester.pumpAndSettle();

          // Verify the counter starts at 0.
          expect(find.text('KASI MONATE APPKASI MONATE APP'), findsOneWidget);

          await tester.pumpAndSettle();

          // Find all the element
          final Finder phone = find.byKey(const Key('Phone'));
          final Finder password = find.byKey(const Key('Password'));
          final Finder loginBtn = find.byKey(const Key('Login'));

          // Enter all the login information
          await tester.enterText(phone, '0824815280');
          await tester.enterText(password, '12345');

          // Click on login button
          await tester.tap(loginBtn);

          // Trigger a frame.
          await tester.pumpAndSettle();

          // Verify the counter increments by 1.
          expect(find.text('Kasi Monate App'), findsOneWidget);
        });
  });
}