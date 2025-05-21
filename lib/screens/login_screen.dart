import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/device_service.dart';
import 'home_screen.dart';
import 'package:hive/hive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  void _login() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    final deviceId = await getDeviceId();
    final uniqueKey = '$email-$deviceId';

    await _secureStorage.write(key: 'user_email', value: email);
    await _secureStorage.write(key: 'device_id', value: deviceId);
    await _secureStorage.write(key: 'user_key', value: uniqueKey);

    if (!Hive.isBoxOpen(uniqueKey)) {
      await Hive.openBox('invoices_$uniqueKey'); // personalized box
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Enter your email"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
