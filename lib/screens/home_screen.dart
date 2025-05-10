// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'create_invoice_screen.dart';
import 'view_invoices_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice App Home'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Create Invoice'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const CreateInvoiceScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.list),
              label: const Text('View Invoices'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ViewInvoicesScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
