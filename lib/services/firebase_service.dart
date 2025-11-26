import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contact.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'contacts';

  // Add a new contact to Firestore
  Future<void> addContact(Contact contact) async {
    try {
      await _firestore
          .collection(_collectionName)
          .add(contact.toMap());
    } catch (e) {
      throw Exception('Failed to add contact: $e');
    }
  }

  // Get all contacts from Firestore
  Future<List<Contact>> getAllContacts() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection(_collectionName).get();

      final List<Contact> contacts = [];
      for (var doc in querySnapshot.docs) {
        contacts.add(Contact.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        ));
      }
      return contacts;
    } catch (e) {
      throw Exception('Failed to fetch contacts: $e');
    }
  }

  // Get contacts as a stream (real-time updates)
  Stream<List<Contact>> getContactsStream() {
    try {
      return _firestore
          .collection(_collectionName)
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        final List<Contact> contacts = [];
        for (var doc in querySnapshot.docs) {
          contacts.add(Contact.fromMap(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ));
        }
        return contacts;
      });
    } catch (e) {
      throw Exception('Failed to get contacts stream: $e');
    }
  }

  // Update a contact
  Future<void> updateContact(Contact contact) async {
    try {
      if (contact.id == null) {
        throw Exception('Contact ID is required for update');
      }
      await _firestore
          .collection(_collectionName)
          .doc(contact.id)
          .update(contact.toMap());
    } catch (e) {
      throw Exception('Failed to update contact: $e');
    }
  }

  // Delete a contact
  Future<void> deleteContact(String contactId) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(contactId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete contact: $e');
    }
  }
}
