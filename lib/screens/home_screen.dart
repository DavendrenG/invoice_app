import 'package:flutter/material.dart';
import 'create_invoice_screen.dart';
import 'view_invoices_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Advent Agency Invoice App Home'),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // 2 tiles per row
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildTile(
              context,
              title: 'Create Invoice',
              icon: Icons.add_circle_outline,
              color: Colors.green,
              destination: const CreateInvoiceScreen(),
            ),
            _buildTile(
              context,
              title: 'View Invoices',
              icon: Icons.receipt_long,
              color: Colors.blue,
              destination: ViewInvoicesScreen(),
            ),
            // Add more tiles here if needed
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required Widget destination}) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(2, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
