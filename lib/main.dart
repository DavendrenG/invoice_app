import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invoice_app/screens/splash_screen.dart';
import 'models/invoice.dart';
import 'models/invoice_item.dart';
import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(InvoiceAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(InvoiceItemAdapter());
  }

  await Hive.openBox<Invoice>('invoices');

  runApp(const MyApp());
}
y
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 🔴 Kill switch flag – change this and push with Shorebird
  static const bool isAppDisabled = false; // Set to true in Shorebird patch

  // Optional message
  static const String killMessage =
      "🚫 This version is blocked!. Please contact verningpodcast@gmail.com to request access.";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invoice App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pinkAccent,
          foregroundColor: Colors.white38,
        ),
      ),
      home: const SplashScreen(), // or your home screen
    );
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
