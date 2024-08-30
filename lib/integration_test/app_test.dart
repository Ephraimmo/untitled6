import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:untitled6/main.dart' as app;

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey = 'pk_test_51NMSvDAd90R6y6g69QWrbnDFnWTbU2x5Zb6Wistfy5kzG5nbOyejdzi1tht2nxNa0ilgjdnCMzdiDjhhYrCyVoXd00v7MlEB7H';

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
            (tester) async {
          app.main();
          await tester.pumpAndSettle();

          // Verify the counter starts at 0.
          //expect(find.text('Login'), findsOneWidget);

          Future.delayed(Duration(seconds: 1));
          await tester.pumpAndSettle();

          // Finds the floating action button to tap on.
          final Finder Phone       = find.byKey(const Key("Phone"));
          final Finder Password    = find.byKey(const Key("Password"));
          final Finder LoginButton = find.byKey(const Key("LoginButton"));

          // Emulate a tap on the floating action button.
          await tester.enterText(Phone, '0824815280');
          await tester.enterText(Password, '11111');
          await tester.pumpAndSettle();
          await tester.tap(LoginButton);

          await tester.pumpAndSettle();

          Future.delayed(Duration(seconds: 5));
          await tester.pumpAndSettle();

//
          // Verify the counter increments by 1.
          expect(find.text('Kasi Monate App'), findsOneWidget);
          expect(find.text('Branche 1'), findsOneWidget);
        });
  });
}