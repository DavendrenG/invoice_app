import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'models/invoice.dart';
import 'models/invoice_item.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register adapters
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(InvoiceAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(InvoiceItemAdapter());
  }

  await Hive.openBox<Invoice>('invoices');

  // 🔐 Remote kill switch check
  final response = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/DavendrenG/invoice_app/blob/master/config.json'));

  bool isAppDisabled = false;
  String disableMessage = "This app is currently unavailable.";

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    isAppDisabled = jsonData['isAppDisabled'] ?? false;
    disableMessage = jsonData['message'] ?? disableMessage;
  }

  runApp(MyApp(isAppDisabled: isAppDisabled, disableMessage: disableMessage));
}

class MyApp extends StatelessWidget {
  final bool isAppDisabled;
  final String disableMessage;

  const MyApp(
      {super.key, required this.isAppDisabled, required this.disableMessage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invoice App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isAppDisabled
          ? DisabledAppScreen(message: disableMessage)
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
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
