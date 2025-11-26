# Aplikasi Buku Kontak

Aplikasi sederhana untuk mengelola daftar kontak menggunakan Flutter.

## Fitur Utama

### 1. Daftar Kontak
- Menampilkan daftar semua kontak yang tersimpan
- Tampilan list dengan informasi ringkas setiap kontak

### 2. Halaman Tambah Kontak
- Form untuk menambahkan kontak baru
- Input data kontak (nama, nomor telepon, dll)
- Validasi input

### 3. Profil/Detail Kontak
- Menampilkan detail lengkap kontak
- Opsi untuk mengedit informasi kontak
- Fitur hapus kontak

## Workflow Aplikasi

```
Menambah kontak → Menampilkan daftar → Membuka detail dan mengedit
```

### Alur Penggunaan:
1. **Tambah Kontak**: Pengguna dapat menambahkan kontak baru melalui halaman tambah kontak
2. **Lihat Daftar**: Semua kontak ditampilkan dalam bentuk list di halaman utama
3. **Detail Kontak**: Tap pada kontak untuk melihat detail lengkap
4. **Edit Kontak**: Dari halaman detail, pengguna dapat mengedit informasi kontak
5. **Hapus Kontak**: Opsi untuk menghapus kontak dari daftar

## Teknologi

- **Framework**: Flutter
- **Bahasa**: Dart
- **State Management**: Provider/setState (dapat disesuaikan)
- **Storage**: Local storage (SharedPreferences/SQLite)

## Instalasi

1. Clone repository ini:
```bash
git clone <repository-url>
cd flutter_application_2
```

2. Install dependencies:
```bash
flutter pub get
```

3. Jalankan aplikasi:
```bash
flutter run
```

## Struktur Project

```
lib/
├── main.dart                 # Entry point aplikasi
├── models/
│   └── contact.dart         # Model data kontak
├── screens/
│   ├── contact_list.dart    # Halaman daftar kontak
│   ├── add_contact.dart     # Halaman tambah kontak
│   └── contact_detail.dart  # Halaman detail kontak
└── widgets/
    └── contact_card.dart    # Widget card untuk item kontak
```

## Pengembangan Selanjutnya

- [ ] Implementasi pencarian kontak
- [ ] Sorting berdasarkan nama/tanggal
- [ ] Integrasi dengan kontak perangkat
- [ ] Backup dan restore data
- [ ] Tema dark mode
- [ ] Export/import kontak

## Kontribusi

Pull requests are welcome! Untuk perubahan besar, silakan buka issue terlebih dahulu untuk mendiskusikan perubahan yang diinginkan.

## Lisensi

[MIT](https://choosealicense.com/licenses/mit/)
