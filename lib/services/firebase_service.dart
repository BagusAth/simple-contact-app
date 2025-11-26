import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/contact.dart';

class FirebaseService {
  FirebaseService._internal();
  static FirebaseService? _instance;
  factory FirebaseService() => _instance ??= FirebaseService._internal();

  CollectionReference<Map<String, dynamic>> get _contactsRef =>
      FirebaseFirestore.instance.collection('contacts');

  Stream<List<Contact>> watchContacts() {
    return _contactsRef
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Contact.fromMap(doc.data(), id: doc.id))
              .toList(),
        );
  }

  Future<void> addContact(Contact contact) {
    return _contactsRef.add(contact.toMap());
  }

  Future<void> updateContact(Contact contact) {
    if (contact.id.isEmpty) {
      throw ArgumentError('Contact id is required for update');
    }
    return _contactsRef.doc(contact.id).update(contact.toMap());
  }

  Future<void> deleteContact(String id) {
    return _contactsRef.doc(id).delete();
  }

  Future<void> updateFavorite(String id, bool isFavorite) {
    return _contactsRef.doc(id).update({'isFavorite': isFavorite});
  }
}
