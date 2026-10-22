# Modul 06 — Login & Session Dasar

- **Nama:** Jihad Akbar
- **NIM:** 362558302003
- **Kelas:** 2E

---

## Bukti Screenshot

(<ss/Screenshot 2026-10-22 at 11.31.51.png>)
(<ss/Screenshot 2026-10-22 at 11.32.21.png>)
(<ss/Screenshot 2026-10-22 at 11.32.46.png>)
(<ss/Screenshot 2026-10-22 at 11.34.35.png>)
(<ss/Screenshot 2026-10-22 at 11.35.36.png>)

---

## Jawaban Refleksi

**1. Pertanyaan baru setelah sesi mulai bertahan?**

Pertanyaannya: *berapa lama sesi boleh disimpan, dan apa yang terjadi kalau sesi itu dicuri?* Waktu sesi cuma di memori, jawabannya otomatis: sampai aplikasi ditutup, dan tidak ada berkas yang bisa dicuri. Setelah sesi ditulis ke penyimpanan, saya harus menentukan sendiri masa berlakunya dan ada data di disk yang bisa dibaca orang lain. Makanya di Fase B ada keadaan `kedaluwarsa` dan pengecekan sesi saat aplikasi dibuka lagi.

**2. Salah paham soal tombol kembali**

Tombol kembali cuma menutup layar, proses aplikasinya masih hidup, jadi `SesiMemori` masih ada. Kalau seseorang tekan kembali lalu buka aplikasi dan masih login, dia bisa mengira sesinya sudah tersimpan permanen. Padahal sesi itu masih ada cuma karena prosesnya belum mati. Kesimpulannya salah, dan bahayanya dia merasa penyimpanannya sudah beres padahal belum teruji. Cara yang benar untuk menguji adalah mematikan proses aplikasi (tutup dari app switcher, atau refresh halaman kalau di Chrome). Hasilnya sesi hilang dan kembali ke form login.

**3. Pesan "Email atau kata sandi salah" yang tidak menyebut mana yang keliru**

Menurut saya itu sedikit merepotkan pengguna, tapi manfaatnya lebih besar. Kalau pesannya "email tidak terdaftar", penyerang bisa menebak banyak email dan tahu mana yang punya akun, lalu menyerang akun itu saja. Dengan pesan umum, daftar pengguna tidak bocor. Pengguna asli tinggal cek ulang email dan sandinya, jadi ruginya kecil. Di tes juga dibuktikan: email tidak terdaftar dan sandi salah menghasilkan pesan yang sama.

**4. SharedPreferences memenuhi kontrak, terus apa yang salah?**

Implementasinya tidak salah. `PrefsSesiRepository` memang bisa simpan, baca, dan hapus sesi sesuai kontrak. Yang salah adalah **pilihan tempatnya**: SharedPreferences dibuat untuk preferensi biasa, bukan untuk rahasia seperti token, dan tidak memberi jaminan secure storage. Di papan diagnostik, tombol "Intip" memperlihatkan token apa adanya untuk Prefs, sedangkan untuk Aman hasilnya `null`. Jadi "salah implementasi" dan "pilihan yang tidak tepat" itu beda. Salah implementasi artinya kodenya tidak sesuai kontrak. Pilihan tidak tepat artinya kodenya benar tapi dipakai untuk hal yang tidak cocok. Yang kedua lebih bahaya karena tidak ada error dan aplikasinya kelihatan normal.

**5. Setelah tahu batas penyimpanan aman, token masih perlu disimpan di perangkat?**

Menurut saya masih perlu, tapi dengan syarat. Kalau tidak disimpan, pengguna harus mengetik kata sandi tiap buka aplikasi, dan itu juga ada risikonya. Batas penyimpanan aman artinya dia bukan satu-satunya pengaman, bukan berarti penyimpanan ditinggalkan. Yang bisa dilakukan:

- simpan di penyimpanan aman platform, bukan di Prefs
- kasih masa berlaku yang pendek dan buang sesi yang sudah kedaluwarsa
- server tetap memeriksa token di setiap permintaan dan bisa mencabutnya
- jangan tulis token ke log, screenshot, atau repositori

Kalau datanya sangat sensitif, keputusannya bisa beda, misalnya minta login ulang lebih sering. Jadi tergantung seberapa penting datanya.