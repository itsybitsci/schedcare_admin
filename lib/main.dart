import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schedcare_admin/config/config.dart';
import 'package:schedcare_admin/screens/authentication/login_screen.dart';
import 'package:schedcare_admin/screens/home/home_screen.dart';
import 'package:schedcare_admin/utilities/firebase_options.dart';
import 'package:schedcare_admin/services/recaptcha_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: Config.siteKey,
  );

  //Initialize reCAPTCHA
  await RecaptchaService.initiate();

  runApp(
    const ProviderScope(
      child: SchedcareAdminApp(),
    ),
  );
}

class SchedcareAdminApp extends StatelessWidget {
  const SchedcareAdminApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SchedCare Admin Portal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => const HomeScreen()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
