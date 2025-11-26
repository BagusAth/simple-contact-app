class Contact {
  final String name;
  final String phone;
  final String email;

  Contact({
    required this.name,
    required this.phone,
    required this.email,
  });

  // Get initials from name for avatar
  String getInitials() {
    List<String> names = name.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0].substring(0, names[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'NA';
  }
}
