import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/contact.dart';
import '../services/firebase_service.dart';
import 'add_contact.dart';
import 'contact_detail.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _alphabetKey = GlobalKey();
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  Map<String, GlobalKey> _letterKeys = {};
  List<String> _availableLetters = [];
  String? _currentLetter;
  OverlayEntry? _overlayEntry;
  StreamSubscription<List<Contact>>? _contactSubscription;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _subscribeToContacts();
  }

  void _subscribeToContacts() {
    _contactSubscription = _firebaseService.watchContacts().listen(
      (contacts) {
        contacts.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        setState(() {
          _contacts = contacts;
          _filteredContacts = _applyFilter(_searchController.text, contacts);
          _isLoading = false;
          _updateAvailableLetters();
        });
      },
      onError: (_) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memuat kontak dari server.')),
        );
      },
    );
  }

  void _updateAvailableLetters() {
    final letters = <String>{};
    for (final contact in _filteredContacts) {
      final letter = _letterForContact(contact);
      if (letter.isNotEmpty) {
        letters.add(letter);
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
      _filteredContacts = _applyFilter(query);
      _updateAvailableLetters();
    });
  }

  List<Contact> _applyFilter(String query, [List<Contact>? source]) {
    final origin = source ?? _contacts;
    if (query.trim().isEmpty) {
      return List<Contact>.from(origin);
    }
    final term = query.toLowerCase();
    return origin
        .where(
          (contact) =>
              contact.name.toLowerCase().contains(term) ||
              contact.phone.toLowerCase().contains(term) ||
              contact.email.toLowerCase().contains(term),
        )
        .toList();
  }

  void _showLetterOverlay(String letter) {
    _removeLetterOverlay();

    _currentLetter = letter;
    _overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF22D3EE),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                letter,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeLetterOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _currentLetter = null;
  }

  @override
  void dispose() {
    _removeLetterOverlay();
    _contactSubscription?.cancel();
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
                        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildContactList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddContactScreen()));
        },
        backgroundColor: const Color(0xFF22D3EE),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildContactList() {
    if (_filteredContacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              'Tidak ada kontak ditemukan',
              style: TextStyle(fontSize: 16, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.only(left: 24, right: 48, bottom: 24),
          itemCount: _filteredContacts.length,
          itemBuilder: (context, index) {
            final contact = _filteredContacts[index];
            final currentLetter = _letterForContact(contact);
            final previousLetter = index > 0
                ? _letterForContact(_filteredContacts[index - 1])
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
        Positioned(
          right: 4,
          top: 0,
          bottom: 0,
          child: _buildAlphabetNavigator(),
        ),
      ],
    );
  }

  Widget _buildAlphabetNavigator() {
    return GestureDetector(
      key: _alphabetKey,
      onVerticalDragStart: (details) {
        _handleAlphabetTouch(details.globalPosition);
      },
      onVerticalDragUpdate: (details) {
        _handleAlphabetTouch(details.globalPosition);
      },
      onVerticalDragEnd: (_) {
        _removeLetterOverlay();
      },
      child: Container(
        width: 32,
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(26, (index) {
            final letter = String.fromCharCode(65 + index); // A-Z
            final isAvailable = _availableLetters.contains(letter);

            return GestureDetector(
              onTap: isAvailable ? () => _scrollToLetter(letter) : null,
              child: Container(
                height: 16,
                width: 32,
                alignment: Alignment.center,
                child: Text(
                  letter,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isAvailable
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isAvailable
                        ? const Color(0xFF22D3EE)
                        : const Color(0xFFCBD5E1),
                    height: 1.0,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _handleAlphabetTouch(Offset globalPosition) {
    final RenderBox? box =
        _alphabetKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final localPosition = box.globalToLocal(globalPosition);
    final padding = 12.0; // vertical padding
    final adjustedY = localPosition.dy - padding;

    // Calculate which letter is being touched based on position
    // Total height = 26 letters * 16 height per letter
    final totalHeight = 26 * 16.0;

    if (adjustedY >= 0 && adjustedY <= totalHeight) {
      final itemIndex = (adjustedY / 16).floor();
      if (itemIndex >= 0 && itemIndex < 26) {
        final touchedLetter = String.fromCharCode(65 + itemIndex);
        if (_availableLetters.contains(touchedLetter)) {
          if (touchedLetter != _currentLetter) {
            _showLetterOverlay(touchedLetter);
            _scrollToLetter(touchedLetter);
          }
        }
      }
    }
  }

  Widget _buildContactCard(Contact contact) {
    final displayName = contact.name.isEmpty
        ? 'Kontak Tanpa Nama'
        : contact.name;
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
                // Avatar with photo or initials
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22D3EE).withOpacity(0.2),
                    shape: BoxShape.circle,
                    image: contact.photoBase64 != null
                        ? DecorationImage(
                            image: MemoryImage(
                              base64Decode(contact.photoBase64!),
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: contact.photoBase64 == null
                      ? Center(
                          child: Text(
                            contact.getInitials(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF22D3EE),
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                // Contact Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
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
                const Icon(Icons.chevron_right, color: Color(0xFF64748B)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _letterForContact(Contact contact) {
    final trimmed = contact.name.trim();
    if (trimmed.isEmpty) {
      return '#';
    }
    return trimmed[0].toUpperCase();
  }
}
