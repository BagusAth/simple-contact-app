import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/contact.dart';
import '../services/firebase_service.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  final _firebaseService = FirebaseService();
  final _imagePicker = ImagePicker();
  bool _isLoading = false;
  String? _photoBase64;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _photoBase64 = base64Encode(bytes);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (photo != null) {
        final bytes = await photo.readAsBytes();
        setState(() {
          _photoBase64 = base64Encode(bytes);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error taking photo: $e')),
        );
      }
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF22D3EE)),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF22D3EE)),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
              if (_photoBase64 != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Remove Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _photoBase64 = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveContact() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final fullName =
            '${_firstNameController.text} ${_lastNameController.text}'.trim();

        final contact = Contact(
          name: fullName,
          phone: _phoneController.text,
          email: _emailController.text,
          address: _addressController.text,
          notes: _noteController.text,
          photoBase64: _photoBase64,
        );

        await _firebaseService.addContact(contact);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kontak berhasil ditambahkan'),
              backgroundColor: Color(0xFF22D3EE),
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  String _getInitials() {
    String first = _firstNameController.text.isNotEmpty
        ? _firstNameController.text[0].toUpperCase()
        : '';
    String last = _lastNameController.text.isNotEmpty
        ? _lastNameController.text[0].toUpperCase()
        : '';
    return '$first$last'.isEmpty ? '?' : '$first$last';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          icon: const Icon(Icons.delete_outline),
          color: Colors.redAccent,
          tooltip: 'Batalkan',
        ),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _saveContact,
            icon: const Icon(Icons.check_circle_outline),
            color: _isLoading ? Colors.grey : Colors.green,
            tooltip: 'Simpan',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Avatar Circle with Photo or Initial
              GestureDetector(
                onTap: _showPhotoOptions,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22D3EE),
                    shape: BoxShape.circle,
                    image: _photoBase64 != null
                        ? DecorationImage(
                            image: MemoryImage(base64Decode(_photoBase64!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _photoBase64 == null
                      ? Center(
                          child: Text(
                            _getInitials(),
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              // Add Photo Button
              GestureDetector(
                onTap: _showPhotoOptions,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _photoBase64 == null ? Icons.add_a_photo : Icons.edit,
                        size: 16,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _photoBase64 == null ? 'Add Photo' : 'Change Photo',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // First Name
                    _buildTextField(
                      controller: _firstNameController,
                      label: 'First Name',
                      hint: 'First Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First name cannot be empty';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 12),
                    // Last Name
                    _buildTextField(
                      controller: _lastNameController,
                      label: 'Last Name',
                      hint: 'Last Name',
                      validator: (value) {
                        return null; // Optional
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 12),
                    // Phone
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone',
                      hint: 'Add Phone',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone cannot be empty';
                        }
                        if (value.length < 10) {
                          return 'Phone must be at least 10 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    // Email
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Add Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        if (!value.contains('@')) {
                          return 'Email must be valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    // Address (optional)
                    _buildTextField(
                      controller: _addressController,
                      label: 'Address',
                      hint: 'Address',
                      validator: (value) {
                        return null; // Optional
                      },
                    ),
                    const SizedBox(height: 12),
                    // Note (optional)
                    _buildTextField(
                      controller: _noteController,
                      label: 'Note',
                      hint: 'Add Note',
                      maxLines: 4,
                      validator: (value) {
                        return null; // Optional
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF22D3EE), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
