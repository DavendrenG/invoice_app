import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/invoice.dart';
import 'models/invoice_item.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 🔴 Kill switch flag – change this and push with Shorebird
  static const bool isAppDisabled = false; // Set to true in Shorebird patch

  // Optional message
  static const String killMessage =
      "🚫 This version is blocked. Please update to continue.";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invoice App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isAppDisabled
          ? const DisabledAppScreen(message: killMessage)
          : const HomeScreen(),
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
