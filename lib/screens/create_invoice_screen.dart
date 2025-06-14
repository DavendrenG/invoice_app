import 'package:flutter/material.dart';
import '../models/invoice.dart';
import '../models/invoice_item.dart';
import 'package:hive/hive.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _invoiceNumberController = TextEditingController();
  final _invoiceDateController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _notesController = TextEditingController();
  final _termsController = TextEditingController();

  List<InvoiceItem> items = [];

  void _saveInvoice() {
    if (_formKey.currentState!.validate()) {
      final invoice = Invoice(
        customerName: _customerNameController.text,
        customerEmail: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        invoiceNumber: _invoiceNumberController.text,
        invoiceDate:
            DateTime.tryParse(_invoiceDateController.text) ?? DateTime.now(),
        dueDate: DateTime.tryParse(_dueDateController.text) ?? DateTime.now(),
        items: items,
        notes: _notesController.text,
        terms: _termsController.text,
      );

      Hive.box<Invoice>('invoices').add(invoice);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice Saved')),
      );
      Navigator.pop(context);
    }
  }

  void _addItem() async {
    final newItem = await showDialog<InvoiceItem>(
      context: context,
      builder: (context) {
        final descriptionController = TextEditingController();
        final quantityController = TextEditingController(text: '1');
        final priceController = TextEditingController(text: '0');

        return AlertDialog(
          title: const Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final item = InvoiceItem(
                  description: descriptionController.text,
                  quantity: int.tryParse(quantityController.text) ?? 1,
                  price: double.tryParse(priceController.text) ?? 0.0,
                );
                Navigator.pop(context, item);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (newItem != null) {
      setState(() {
        items.add(newItem);
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Invoice')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _customerNameController,
                  decoration: const InputDecoration(labelText: 'Customer Name'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                TextFormField(
                  controller: _invoiceNumberController,
                  decoration:
                      const InputDecoration(labelText: 'Invoice Number'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _invoiceDateController,
                  decoration: const InputDecoration(
                      labelText: 'Invoice Date (yyyy-mm-dd)'),
                ),
                TextFormField(
                  controller: _dueDateController,
                  decoration:
                      const InputDecoration(labelText: 'Due Date (yyyy-mm-dd)'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addItem,
                  child: const Text('Add Item'),
                ),
                const SizedBox(height: 10),
                ...items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return ListTile(
                    title: Text(item.description),
                    subtitle: Text(
                      'Qty: ${item.quantity}, Price: ${item.price.toStringAsFixed(2)}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeItem(index),
                    ),
                  );
                }).toList(),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
                TextFormField(
                  controller: _termsController,
                  decoration: const InputDecoration(labelText: 'Terms'),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveInvoice,
                    child: const Text('Save Invoice'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
