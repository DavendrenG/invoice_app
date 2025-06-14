import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'models/invoice.dart';
import 'models/invoice_item.dart';
import 'models/company_info.dart';

import 'screens/splash_screen.dart';
import 'screens/company_setup_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Register all adapters
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(InvoiceAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(InvoiceItemAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(CompanyInfoAdapter());
  }

  // Open required boxes
  await Hive.openBox<Invoice>('invoices');
  await Hive.openBox<CompanyInfo>('companyInfo');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // ✅ Kill switch flag – works with Shorebird patches
  static const bool isAppDisabled = false; // Set to true to disable app
  static const String killMessage =
      "🚫 This version has been blocked. Please contact verningpodcast@gmail.com to request access.";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invoice App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.pinkAccent,
          foregroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: isAppDisabled
          ? const DisabledAppScreen(message: killMessage)
          : const AppInitializer(),
    );
  }
}

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    final companyBox = Hive.box<CompanyInfo>('companyInfo');
    final isCompanySet = companyBox.isNotEmpty;

    // ✅ Show company setup if not configured yet
    return isCompanySet ? const SplashScreen() : const CompanySetupScreen();
  }
}

class DisabledAppScreen extends StatelessWidget {
  final String message;
  const DisabledAppScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade900,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
