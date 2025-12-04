# 📱 Aplikasi Buku Kontak

Aplikasi mobile untuk mengelola daftar kontak menggunakan Flutter dengan integrasi Firebase Firestore sebagai backend database.

---

## ✨ Fitur Utama

### 1. 📋 Daftar Kontak (Contact List)
- Menampilkan semua kontak yang tersimpan di Firebase
- **Alphabet Navigator** di sisi kanan untuk navigasi cepat A-Z
- **Popup huruf** saat drag alphabet navigator
- **Search bar** untuk mencari kontak berdasarkan nama, telepon, atau email
- Avatar dengan foto profil atau inisial nama
- Section header berdasarkan huruf pertama nama

### 2. ➕ Tambah Kontak (Add Contact)
- Form input lengkap: First Name, Last Name, Phone, Email, Address, Notes
- **Upload foto profil** dari galeri atau kamera
- Foto disimpan dalam format **Base64 String**
- Validasi input (nama, telepon, email wajib diisi)
- Preview avatar dengan foto atau inisial

### 3. 👤 Detail Kontak (Contact Detail)
- Menampilkan informasi lengkap kontak
- **Foto profil** ditampilkan dalam avatar besar
- Quick action buttons: Telepon, Pesan, Favorit
- Mode edit untuk mengubah informasi kontak
- Opsi hapus kontak dengan konfirmasi dialog

### 4. ✏️ Edit Kontak
- Edit semua informasi kontak langsung dari halaman detail
- Tombol Simpan dan Batal
- Perubahan tersimpan otomatis ke Firebase

### 5. ⭐ Favorit
- Tandai kontak sebagai favorit
- Status favorit tersimpan di database

---

## 🛠️ Teknologi yang Digunakan

| Teknologi | Keterangan |
|-----------|------------|
| **Flutter** | Framework UI untuk cross-platform mobile development |
| **Dart** | Bahasa pemrograman utama |
| **Firebase Firestore** | Cloud database NoSQL untuk menyimpan data kontak |
| **Firebase Core** | Core library untuk integrasi Firebase |
| **Image Picker** | Package untuk mengambil gambar dari galeri/kamera |
| **Base64 Encoding** | Metode penyimpanan foto profil |

---

## 📁 Struktur Project

```
lib/
├── main.dart                      # Entry point aplikasi
├── firebase_options.dart          # Konfigurasi Firebase
├── models/
│   └── contact.dart               # Model data kontak
├── screens/
│   ├── contact_list_screen.dart   # Halaman daftar kontak
│   ├── add_contact.dart           # Halaman tambah kontak
│   └── contact_detail.dart        # Halaman detail kontak
└── services/
    └── firebase_service.dart      # Service untuk operasi Firebase
```

---

## 🎨 Desain UI

### Warna Tema
- **Primary (Cyan)**: `#22D3EE` - Warna utama untuk accent dan button
- **Background Light**: `#F8FAFC` - Background aplikasi
- **Text Dark**: `#0F172A` - Warna teks utama
- **Text Secondary**: `#64748B` - Warna teks sekunder

### Komponen UI
- **Card Design** dengan rounded corners dan shadow
- **Avatar Circle** dengan foto atau inisial
- **Alphabet Navigator** dengan popup saat drag
- **Modern Form Fields** dengan validasi

---

## 🚀 Cara Menjalankan

### Prasyarat
- Flutter SDK (versi 3.9.2 atau lebih baru)
- Dart SDK
- Android Studio / VS Code
- Firebase Project yang sudah dikonfigurasi

### Langkah Instalasi

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd simple-contact-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Konfigurasi Firebase**
   - Buat project di [Firebase Console](https://console.firebase.google.com/)
   - Jalankan FlutterFire CLI:
     ```bash
     flutterfire configure
     ```
   - Pastikan `firebase_options.dart` sudah ter-generate

4. **Jalankan aplikasi**
   ```bash
   flutter run
   ```

---

## 📱 Platform yang Didukung

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

---

## 📝 Model Data Kontak

```dart
class Contact {
  String id;
  String name;
  String phone;
  String email;
  String address;
  String notes;
  bool isFavorite;
  String? photoBase64;  // Foto profil dalam format Base64
}
```

---

## 🔧 Operasi Database

| Operasi | Method | Keterangan |
|---------|--------|------------|
| Create | `addContact()` | Menambah kontak baru |
| Read | `getContacts()` | Mengambil semua kontak (stream) |
| Update | `updateContact()` | Mengupdate data kontak |
| Delete | `deleteContact()` | Menghapus kontak |
| Favorite | `updateFavorite()` | Toggle status favorit |

---
