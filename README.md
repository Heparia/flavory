# Flavory

**Flavory** adalah aplikasi Android lintas platform yang dikembangkan menggunakan Flutter dan Dart. Aplikasi ini dirancang untuk mempermudah berbagi resep makanan, dengan integrasi Firebase untuk autentikasi dan pengelolaan data pengguna.

## Anggota Kelompok
- **Heparia Arum Ndaru Ramdhani**  
- **Maranatha Nur Chiesa**  
- **Seli Agustina**  
- **Zahra 'Arf Walidain**

## Fitur Utama
- **Autentikasi Pengguna**  
  Autentikasi email dan password yang terintegrasi dengan Firebase, termasuk fitur registrasi, login, lupa kata sandi, dan logout.  
- **Pencarian Resep**  
  Fitur pencarian untuk menemukan semua resep yang tersedia di database (Firestore), lengkap dengan detail resep.  
- **Profil Pengguna**  
  - Menampilkan informasi identitas pengguna dan daftar resep yang dibuat oleh pengguna.  
  - Pengguna dapat mengedit informasi identitas mereka.  
  - Pengguna dapat menghapus resep yang telah mereka buat.  
- **Tambah Resep Baru**  
  Fitur untuk menambahkan resep baru ke dalam database.

---

## Panduan Instalasi di Android

Ikuti langkah-langkah berikut untuk menginstal aplikasi **Flavory** di perangkat Android Anda:

### 1. **Prasyarat**
- Pastikan Anda telah menginstal **Flutter SDK** di komputer Anda.  
  [Panduan Instalasi Flutter](https://flutter.dev/docs/get-started/install)  
- Pastikan **Android Studio** telah terinstal dan dikonfigurasi.  
- Perangkat Android (fisik atau emulator) dengan Android versi 6.0 (Marshmallow) atau lebih baru.  

### 2. **Clone Repository**
Clone proyek ini ke komputer Anda dengan perintah berikut:
```bash
git clone https://github.com/username/flavory.git
cd flavory
```

### 3. **Install Dependencies**
Instal semua dependensi yang diperlukan dengan menjalankan perintah:
```bash
flutter pub get
```

### 4. **Konfigurasi Firebase**
- Unduh file **google-services.json** dari Firebase Console untuk proyek ini.  
- Tempatkan file **google-services.json** di direktori `android/app/`.

### 5. **Jalankan Aplikasi**
- Hubungkan perangkat Android ke komputer Anda atau jalankan emulator Android.  
- Jalankan perintah berikut untuk memulai aplikasi:
```bash
flutter run
```

### 6. **Build APK**
Jika Anda ingin membuat file APK untuk instalasi manual:
```bash
flutter build apk --release
```
File APK akan tersedia di direktori `build/app/outputs/flutter-apk/app-release.apk`.

### 7. **Instal APK di Perangkat Android**
- Transfer file APK ke perangkat Android Anda.  
- Instal APK dengan membuka file tersebut di perangkat Anda.  

---

Jika Anda memiliki pertanyaan lebih lanjut, jangan ragu untuk menghubungi salah satu anggota tim. 😊
