import 'package:flutter/material.dart';
import 'theme/theme.dart';
import 'pages/landing_page.dart';
import 'pages/browse_page.dart';
import 'pages/create_request_page.dart';
import 'pages/my_donations_page.dart';
import 'pages/request_details_page.dart';
import 'pages/login_page.dart';
import 'pages/admin_dashboard.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(const CareDropApp());
}

class CareDropApp extends StatelessWidget {
  const CareDropApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareDrop',
      debugShowCheckedModeBanner: false,
      theme: caredropTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashPage(),
        '/': (_) => const LandingPage(),
        '/landing': (_) => const LandingPage(),
        '/browse': (_) => const BrowsePage(),
        '/create': (_) => const CreateRequestPage(),
        '/dashboard': (_) => const MyDonationsPage(),
        '/login': (_) => const LoginPage(), // starts in Login mode
        '/signup': (_) => const LoginPage(), // starts in Register mode
        '/admin': (_) => const AdminDashboardPage(),
        '/request': (_) => const RequestDetailsPage(),
      },
    );
  }
}
