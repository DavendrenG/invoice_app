import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import '../models/company_info.dart';
import 'home_screen.dart';

class CompanySetupScreen extends StatefulWidget {
  const CompanySetupScreen({super.key});

  @override
  State<CompanySetupScreen> createState() => _CompanySetupScreenState();
}

class _CompanySetupScreenState extends State<CompanySetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _enterpriseController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController(); // ✅ Add this
  File? _logo;

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _logo = File(picked.path);
      });
    }
  }

  void _saveCompanyInfo() async {
    if (_formKey.currentState!.validate() && _logo != null) {
      final companyInfo = CompanyInfo(
        name: _nameController.text,
        email: _emailController.text,
        enterpriseNumber: _enterpriseController.text,
        phone: _contactController.text,
        address: _addressController.text, // ✅ Fix applied here
        logoPath: _logo!.path,
      );

      final box = await Hive.openBox<CompanyInfo>('companyInfo');
      await box.clear(); // Only store one instance
      await box.add(companyInfo);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select a logo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Company Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Company Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _enterpriseController,
                decoration:
                    const InputDecoration(labelText: 'Enterprise Number'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Contact Number'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _logo != null
                  ? Image.file(_logo!, height: 100)
                  : const Text('No logo selected'),
              TextButton.icon(
                onPressed: _pickLogo,
                icon: const Icon(Icons.image),
                label: const Text('Select Company Logo'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCompanyInfo,
                child: const Text('Save and Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
