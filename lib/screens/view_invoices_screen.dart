// lib/screens/view_invoices_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import '../models/invoice.dart';
import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ViewInvoicesScreen extends StatefulWidget {
  const ViewInvoicesScreen({Key? key}) : super(key: key);

  @override
  _ViewInvoicesScreenState createState() => _ViewInvoicesScreenState();
}

class _ViewInvoicesScreenState extends State<ViewInvoicesScreen> {
  Box<Invoice>? userBox;

  @override
  void initState() {
    super.initState();
    _loadUserBox();
  }

  Future<void> _loadUserBox() async {
    const secureStorage = FlutterSecureStorage();
    final email = await secureStorage.read(key: 'user_email');
    final deviceId = await secureStorage.read(key: 'device_id');
    final boxName = 'invoices_${email!}-$deviceId';

    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<Invoice>(boxName);
    }

    setState(() {
      userBox = Hive.box<Invoice>(boxName);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userBox == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('All Invoices')),
      body: ValueListenableBuilder(
        valueListenable: userBox!.listenable(),
        builder: (context, Box<Invoice> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No invoices available.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final invoice = box.getAt(index);
              if (invoice == null) return const SizedBox.shrink();

              return ListTile(
                title: Text('Invoice ${invoice.invoiceNumber}'),
                subtitle: Text(invoice.customerName),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewInvoiceScreen(invoice: invoice),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ViewInvoiceScreen extends StatelessWidget {
  final Invoice invoice;
  const ViewInvoiceScreen({Key? key, required this.invoice}) : super(key: key);

  Future<void> _shareInvoicePDF() async {
    final pdf = pw.Document();
    final total = invoice.items
        .fold<double>(0, (sum, item) => sum + item.quantity * item.price);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Invoice: ${invoice.invoiceNumber}',
                  style: pw.TextStyle(fontSize: 20)),
              pw.SizedBox(height: 10),
              pw.Text('Customer: ${invoice.customerName}'),
              pw.Text('Email: ${invoice.customerEmail}'),
              pw.Text('Phone: ${invoice.phone}'),
              pw.Text('Address: ${invoice.address}'),
              pw.SizedBox(height: 10),
              pw.Text('Invoice Date: ${invoice.invoiceDate}'),
              pw.Text('Due Date: ${invoice.dueDate}'),
              pw.SizedBox(height: 20),
              pw.Text('Items:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ...invoice.items.map((item) => pw.Text(
                    '${item.description} | Qty: ${item.quantity} | R${item.price}',
                  )),
              pw.Divider(),
              pw.Text('Total: R${total.toStringAsFixed(2)}'),
              pw.SizedBox(height: 10),
              pw.Text('Notes: ${invoice.notes}'),
              pw.Text('Terms: ${invoice.terms}'),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/invoice_${invoice.invoiceNumber}.pdf");
    await file.writeAsBytes(await pdf.save());
    await Share.shareXFiles([XFile(file.path)],
        text: 'Invoice ${invoice.invoiceNumber}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice ${invoice.invoiceNumber}'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareInvoicePDF,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Customer: ${invoice.customerName}'),
            Text('Email: ${invoice.customerEmail}'),
            Text('Phone: ${invoice.phone}'),
            Text('Address: ${invoice.address}'),
            Text('Invoice Date: ${invoice.invoiceDate.toLocal()}'),
            Text('Due Date: ${invoice.dueDate.toLocal()}'),
            SizedBox(height: 16),
            Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...invoice.items.map((item) => ListTile(
                  title: Text(item.description),
                  subtitle:
                      Text('Qty: ${item.quantity}, Price: R${item.price}'),
                )),
            Divider(),
            Text(
              'Total: R${invoice.items.fold<double>(0, (sum, item) => sum + item.quantity * item.price).toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Notes: ${invoice.notes}'),
            Text('Terms: ${invoice.terms}'),
          ],
        ),
      ),
    );
  }
}
