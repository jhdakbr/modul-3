Laporan Praktikum Modul 03: Navigasi Flutter

* Nama: Jihad Akbar
* NIM: 362558302003
* Kelas / Prodi: 2E TRPL
* Mata Kuliah: Pemrograman Perangkat Bergerak


1. Ringkasan Aktivitas

Pada praktikum Modul 03, saya mempelajari konsep navigasi pada aplikasi Flutter menggunakan Navigator. Navigasi digunakan untuk berpindah dari satu halaman ke halaman lainnya.

Pada tugas ini saya membuat aplikasi perpustakaan sederhana yang berisi daftar beberapa buku, yaitu buku Flutter, Dart, dan UI/UX. Setiap buku memiliki informasi seperti judul, penulis, jumlah buku yang tersedia, tahun, kategori, dan deskripsi.

Ketika pengguna menekan tombol Lihat Detail, aplikasi akan berpindah ke halaman detail menggunakan Navigator.push(). Pada halaman detail, pengguna dapat kembali ke halaman sebelumnya menggunakan Navigator.pop(). Saya juga mempelajari penggunaan Navigator.pushReplacement() untuk mengganti halaman yang sedang aktif.

2. Screenshot Running App

Halaman Daftar Buku

Halaman Detail Buku

Navigasi Aplikasi

3. Kendala yang Dihadapi & Solusinya

* Kendala: Gambar buku tidak muncul karena path asset pada kode tidak sesuai dengan lokasi file.
* Solusi: Menyesuaikan path gambar dengan folder assets/images/ dan mendaftarkan folder tersebut pada pubspec.yaml.
* Kendala: Terjadi error pada pubspec.yaml karena kesalahan penulisan dan indentasi.
* Solusi: Memperbaiki indentasi YAML dan menjalankan kembali flutter pub get.

4. Jawaban Pertanyaan Refleksi

1. Apa fungsi Navigator.push()?

Navigator.push() digunakan untuk membuka halaman baru. Halaman sebelumnya tetap tersimpan sehingga pengguna dapat kembali ke halaman tersebut.

2. Apa fungsi Navigator.pop()?

Navigator.pop() digunakan untuk menutup halaman yang sedang dibuka dan kembali ke halaman sebelumnya.

3. Apa fungsi Navigator.pushReplacement()?

Navigator.pushReplacement() digunakan untuk mengganti halaman yang sedang aktif dengan halaman baru. Halaman sebelumnya tidak lagi menjadi halaman aktif dalam navigation stack.

4. Mengapa navigasi penting dalam aplikasi?

Navigasi penting karena aplikasi biasanya memiliki beberapa halaman. Dengan navigasi, pengguna dapat berpindah halaman sesuai dengan alur aplikasi.

5. Kesimpulan

Melalui praktikum ini, saya memahami dasar navigasi pada Flutter dan cara menerapkan Navigator.push(), Navigator.pop(), serta Navigator.pushReplacement(). Saya juga memahami cara menampilkan asset gambar dan menghubungkan data dari halaman daftar buku ke halaman detail.