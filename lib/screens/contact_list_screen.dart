import 'package:flutter/material.dart';
import '../models/contact.dart';
import 'contact_detail.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  Map<String, GlobalKey> _letterKeys = {};
  List<String> _availableLetters = [];

  @override
  void initState() {
    super.initState();
    _loadSampleContacts();
    _filteredContacts = _contacts;
    _updateAvailableLetters();
  }

  void _loadSampleContacts() {
    _contacts = [
      Contact(
        name: 'Ahmad Rizki',
        phone: '+62 812-3456-7890',
        email: 'ahmad.rizki@email.com',
      ),
      Contact(
        name: 'Siti Nurhaliza',
        phone: '+62 813-4567-8901',
        email: 'siti.nur@email.com',
      ),
      Contact(
        name: 'Budi Santoso',
        phone: '+62 814-5678-9012',
        email: 'budi.santoso@email.com',
      ),
      Contact(
        name: 'Dewi Lestari',
        phone: '+62 815-6789-0123',
        email: 'dewi.lestari@email.com',
      ),
      Contact(
        name: 'Eko Prasetyo',
        phone: '+62 816-7890-1234',
        email: 'eko.prasetyo@email.com',
      ),
      Contact(
        name: 'Fitri Handayani',
        phone: '+62 817-8901-2345',
        email: 'fitri.handayani@email.com',
      ),
    ];
    // Sort contacts by name
    _contacts.sort((a, b) => a.name.compareTo(b.name));
  }

  void _updateAvailableLetters() {
    Set<String> letters = {};
    for (var contact in _filteredContacts) {
      if (contact.name.isNotEmpty) {
        letters.add(contact.name[0].toUpperCase());
      }
    }
    _availableLetters = letters.toList()..sort();
    
    // Create keys for each letter
    _letterKeys.clear();
    for (var letter in _availableLetters) {
      _letterKeys[letter] = GlobalKey();
    }
  }

  void _scrollToLetter(String letter) {
    final key = _letterKeys[letter];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = _contacts;
      } else {
        _filteredContacts = _contacts
            .where((contact) =>
                contact.name.toLowerCase().contains(query.toLowerCase()) ||
                contact.phone.contains(query) ||
                contact.email.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      _updateAvailableLetters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22D3EE),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.contacts,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daftar Kontak',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Kelola dan temukan kontak dengan mudah',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterContacts,
                      decoration: InputDecoration(
                        hintText: 'Cari kontak...',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[400],
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${_filteredContacts.length} kontak ditemukan',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            // Contact List with Alphabet Navigator
            Expanded(
              child: _filteredContacts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_search,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tidak ada kontak ditemukan',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Stack(
                      children: [
                        ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(left: 24, right: 48, bottom: 24),
                          itemCount: _filteredContacts.length,
                          itemBuilder: (context, index) {
                            final contact = _filteredContacts[index];
                            final currentLetter = contact.name[0].toUpperCase();
                            final previousLetter = index > 0
                                ? _filteredContacts[index - 1].name[0].toUpperCase()
                                : '';
                            final showHeader = currentLetter != previousLetter;

                            return Column(
                              key: showHeader ? _letterKeys[currentLetter] : null,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (showHeader)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8, bottom: 12),
                                    child: Text(
                                      currentLetter,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF22D3EE),
                                      ),
                                    ),
                                  ),
                                _buildContactCard(contact),
                              ],
                            );
                          },
                        ),
                        // Alphabet Navigator
                        Positioned(
                          right: 4,
                          top: 0,
                          bottom: 0,
                          child: _buildAlphabetNavigator(),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add contact page
        },
        backgroundColor: const Color(0xFF22D3EE),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAlphabetNavigator() {
    return Container(
      width: 24,
      alignment: Alignment.center,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 26,
        itemBuilder: (context, index) {
          final letter = String.fromCharCode(65 + index); // A-Z
          final isAvailable = _availableLetters.contains(letter);
          
          return GestureDetector(
            onTap: isAvailable ? () => _scrollToLetter(letter) : null,
            child: Container(
              height: 20,
              alignment: Alignment.center,
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isAvailable ? FontWeight.bold : FontWeight.normal,
                  color: isAvailable 
                      ? const Color(0xFF22D3EE)
                      : const Color(0xFFCBD5E1),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContactCard(Contact contact) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ContactDetailScreen(contact: contact),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar with initials
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22D3EE).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      contact.getInitials(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF22D3EE),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Contact Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 14,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            contact.phone,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.email,
                            size: 14,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              contact.email,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF64748B),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
