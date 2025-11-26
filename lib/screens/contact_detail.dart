import 'package:flutter/material.dart';

import '../models/contact.dart';

class ContactDetailScreen extends StatefulWidget {
  const ContactDetailScreen({super.key, this.contact});

  final Contact? contact;

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  late Contact _contact;
  late String _jobTitle;
  late String _company;
  late String _address;
  late String _notes;

  late final TextEditingController _jobTitleController;
  late final TextEditingController _companyController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _contact =
        widget.contact ??
        Contact(
          name: 'Budi Santoso',
          phone: '+62 812 3456 7890',
          email: 'budi.santoso@majubersama.com',
        );

    _jobTitle = 'Manajer Proyek Senior';
    _company = 'PT. Maju Bersama Jaya';
    _address = 'Jl. Merdeka No. 10, Jakarta Pusat, DKI Jakarta, 10120';
    _notes =
        'Kontak penting untuk proyek "Cahaya Nusantara". Selalu ramah dan responsif. Preferensi komunikasi via WhatsApp atau email.';

    _jobTitleController = TextEditingController(text: _jobTitle);
    _companyController = TextEditingController(text: _company);
    _phoneController = TextEditingController(text: _contact.phone);
    _emailController = TextEditingController(text: _contact.email);
    _addressController = TextEditingController(text: _address);
    _notesController = TextEditingController(text: _notes);
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _companyController.dispose();
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
                  onMore: _showMoreOptions,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeroSection(),
                        const SizedBox(height: 16),
                        _buildQuickActions(),
                        const SizedBox(height: 24),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _contact.getInitials(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF22D3EE),
                ),
              ),
            ),
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
          const SizedBox(height: 4),
          _buildEditableText(controller: _jobTitleController, isPrimary: true),
          const SizedBox(height: 2),
          _buildEditableText(controller: _companyController, isPrimary: false),
        ],
      ),
    );
  }

  Widget _buildEditableText({
    required TextEditingController controller,
    required bool isPrimary,
  }) {
    if (_isEditing) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isPrimary ? 18 : 16,
            fontWeight: isPrimary ? FontWeight.w500 : FontWeight.w400,
            color: const Color(0xFF0F172A),
          ),
          decoration: const InputDecoration(
            isDense: true,
            border: UnderlineInputBorder(borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      );
    }

    return Text(
      controller.text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: isPrimary ? 18 : 16,
        fontWeight: isPrimary ? FontWeight.w500 : FontWeight.w400,
        color: const Color(0xFF64748B),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: const [
          _QuickActionButton(icon: Icons.call_outlined, label: 'Telepon'),
          SizedBox(width: 12),
          _QuickActionButton(icon: Icons.chat_bubble_outline, label: 'Pesan'),
          SizedBox(width: 12),
          _QuickActionButton(icon: Icons.star_border, label: 'Favorit'),
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
              onPressed: _handleSave,
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
      _jobTitleController.text = _jobTitle;
      _companyController.text = _company;
      _phoneController.text = _contact.phone;
      _emailController.text = _contact.email;
      _addressController.text = _address;
      _notesController.text = _notes;
      _isEditing = false;
    });
  }

  void _handleSave() {
    setState(() {
      _jobTitle = _jobTitleController.text.trim();
      _company = _companyController.text.trim();
      _contact = Contact(
        name: _contact.name,
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
      );
      _address = _addressController.text.trim();
      _notes = _notesController.text.trim();
      _isEditing = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Perubahan kontak disimpan.')));
  }

  void _showMoreOptions() {
    FocusScope.of(context).unfocus();
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('Bagikan kontak'),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Hapus kontak'),
                onTap: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.isEditing,
    required this.onBack,
    required this.onEdit,
    required this.onMore,
  });

  final String title;
  final bool isEditing;
  final VoidCallback onBack;
  final VoidCallback onEdit;
  final VoidCallback onMore;

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
          IconButton(onPressed: onMore, icon: const Icon(Icons.more_vert)),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
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
            Icon(icon, color: const Color(0xFF2563EB)),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
            ),
          ],
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
