import 'package:flutter_test/flutter_test.dart';

import 'package:auto_care_app/main.dart';
import 'package:auto_care_app/features/auth/screen/login_screen.dart';
import 'package:auto_care_app/features/splash/screen/splash_screen.dart';

void main() {
  testWidgets('App boots to splash and routes to login', (tester) async {
    await tester.pumpWidget(const AutoCareApp());
    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
