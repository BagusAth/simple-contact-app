class Contact {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String jobTitle;
  final String company;
  final String address;
  final String notes;
  final bool isFavorite;
  final String? photoBase64;

  const Contact({
    this.id = '',
    required this.name,
    required this.phone,
    required this.email,
    this.jobTitle = '',
    this.company = '',
    this.address = '',
    this.notes = '',
    this.isFavorite = false,
    this.photoBase64,
  });

  Contact copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? jobTitle,
    String? company,
    String? address,
    String? notes,
    bool? isFavorite,
    String? photoBase64,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
      photoBase64: photoBase64 ?? this.photoBase64,
    );
  }

  // Get initials from name for avatar
  String getInitials() {
    if (name.trim().isEmpty) {
      return 'NA';
    }
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts.first
        .substring(0, parts.first.length >= 2 ? 2 : 1)
        .toUpperCase();
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'jobTitle': jobTitle,
      'company': company,
      'address': address,
      'notes': notes,
      'isFavorite': isFavorite,
      'photoBase64': photoBase64,
    };
  }

  factory Contact.fromMap(Map<String, dynamic>? data, {String id = ''}) {
    final map = data ?? <String, dynamic>{};
    return Contact(
      id: id,
      name: (map['name'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      jobTitle: (map['jobTitle'] ?? '') as String,
      company: (map['company'] ?? '') as String,
      address: (map['address'] ?? '') as String,
      notes: (map['notes'] ?? '') as String,
      isFavorite: (map['isFavorite'] ?? false) as bool,
      photoBase64: map['photoBase64'] as String?,
    );
  }
}
