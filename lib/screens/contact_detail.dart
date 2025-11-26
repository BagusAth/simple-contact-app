import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/contact.dart';
import '../services/firebase_service.dart';

class ContactDetailScreen extends StatefulWidget {
  const ContactDetailScreen({super.key, this.contact});

  final Contact? contact;

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  late Contact _contact;
  late String _address;
  late String _notes;

  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  bool _isEditing = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _contact =
        widget.contact ??
        const Contact(name: 'Kontak Baru', phone: '-', email: '-');

    _address = _contact.address;
    _notes = _contact.notes;
    _isFavorite = _contact.isFavorite;

    _phoneController = TextEditingController(text: _contact.phone);
    _emailController = TextEditingController(text: _contact.email);
    _addressController = TextEditingController(text: _address);
    _notesController = TextEditingController(text: _notes);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                _Header(
                  title: _contact.name,
                  isEditing: _isEditing,
                  onBack: () => Navigator.of(context).maybePop(),
                  onEdit: _toggleEditing,
                  onDelete: _confirmDelete,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeroSection(),
                        const SizedBox(height: 16),
                        if (!_isEditing) _buildQuickActions(),
                        if (!_isEditing) const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildInfoCard(),
                        ),
                        const SizedBox(height: 32),
                        if (_isEditing) _buildEditingActions(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFFEFFCFD),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF22D3EE).withOpacity(0.15),
              border: Border.all(color: Colors.white, width: 4),
              image: _contact.photoBase64 != null
                  ? DecorationImage(
                      image: MemoryImage(
                        base64Decode(_contact.photoBase64!),
                      ),
                      fit: BoxFit.cover,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: _contact.photoBase64 == null
                ? Center(
                    child: Text(
                      _contact.getInitials(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF22D3EE),
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            _contact.name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _QuickActionButton(
            icon: Icons.call_outlined,
            label: 'Telepon',
            onTap: () => _handleQuickAction('Telepon'),
          ),
          const SizedBox(width: 12),
          _QuickActionButton(
            icon: Icons.chat_bubble_outline,
            label: 'Pesan',
            onTap: () => _handleQuickAction('Pesan'),
          ),
          const SizedBox(width: 12),
          _QuickActionButton(
            icon: _isFavorite ? Icons.star : Icons.star_border,
            label: 'Favorit',
            isActive: _isFavorite,
            activeColor: const Color(0xFF22D3EE),
            onTap: _toggleFavorite,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InfoField(
            label: 'Telepon',
            controller: _phoneController,
            isEditing: _isEditing,
            keyboardType: TextInputType.phone,
          ),
          const Divider(height: 32),
          _InfoField(
            label: 'Email',
            controller: _emailController,
            isEditing: _isEditing,
            keyboardType: TextInputType.emailAddress,
          ),
          const Divider(height: 32),
          _InfoField(
            label: 'Alamat',
            controller: _addressController,
            isEditing: _isEditing,
            keyboardType: TextInputType.streetAddress,
            maxLines: 3,
          ),
          const Divider(height: 32),
          _InfoField(
            label: 'Catatan',
            controller: _notesController,
            isEditing: _isEditing,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildEditingActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _handleCancel,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Color(0xFFCBD5F5)),
              ),
              child: const Text('Batal'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _handleSave(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('Simpan'),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleEditing() {
    if (_isEditing) {
      _handleCancel();
    } else {
      setState(() => _isEditing = true);
    }
  }

  void _handleCancel() {
    setState(() {
      _phoneController.text = _contact.phone;
      _emailController.text = _contact.email;
      _addressController.text = _contact.address;
      _notesController.text = _contact.notes;
      _isEditing = false;
    });
  }

  Future<void> _handleSave() async {
    final updated = _contact.copyWith(
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      notes: _notesController.text.trim(),
    );

    setState(() {
      _contact = updated;
      _address = updated.address;
      _notes = updated.notes;
      _isEditing = false;
    });

    if (updated.id.isNotEmpty) {
      await _firebaseService.updateContact(updated);
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Perubahan kontak disimpan.')));
  }

  void _confirmDelete() {
    FocusScope.of(context).unfocus();
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Hapus kontak?'),
          content: Text('Kontak ${_contact.name} akan dihapus.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (_contact.id.isNotEmpty) {
                  _firebaseService.deleteContact(_contact.id);
                }
                Navigator.of(context).maybePop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _handleQuickAction(String action) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Aksi $action belum tersedia.')));
  }

  Future<void> _toggleFavorite() async {
    final newValue = !_isFavorite;
    setState(() {
      _isFavorite = newValue;
      _contact = _contact.copyWith(isFavorite: newValue);
    });
    if (_contact.id.isNotEmpty) {
      await _firebaseService.updateFavorite(_contact.id, newValue);
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.isEditing,
    required this.onBack,
    required this.onEdit,
    required this.onDelete,
  });

  final String title;
  final bool isEditing;
  final VoidCallback onBack;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: Icon(isEditing ? Icons.close : Icons.edit_outlined),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.isActive = false,
    this.activeColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isActive;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final Color accent = activeColor ?? const Color(0xFF2563EB);
    final Color iconColor = isActive ? accent : const Color(0xFF475569);
    final textStyle = TextStyle(
      fontSize: 13,
      color: iconColor,
      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
    );

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: isActive ? accent.withOpacity(0.12) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive ? accent : const Color(0xFFE2E8F0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(icon, color: iconColor, size: 22),
                const SizedBox(height: 6),
                Text(label, style: textStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({
    required this.label,
    required this.controller,
    required this.isEditing,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final bool isEditing;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      fontSize: 13,
      color: Color(0xFF94A3B8),
      letterSpacing: 0.2,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(height: 6),
        if (isEditing)
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF2563EB)),
              ),
            ),
          )
        else
          Text(
            controller.text,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF0F172A),
              height: 1.4,
            ),
          ),
      ],
    );
  }
}
