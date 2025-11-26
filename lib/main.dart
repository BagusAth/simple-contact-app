import 'package:flutter/material.dart';
import 'screens/contact_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Buku Kontak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF22D3EE),
          primary: const Color(0xFF22D3EE),
          secondary: const Color(0xFF0F172A),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const ContactListScreen(),
    );
  }
}
