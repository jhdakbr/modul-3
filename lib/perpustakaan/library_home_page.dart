import 'package:flutter/material.dart';

import 'detail_buku_page.dart';

class LibraryHomePage extends StatelessWidget {
  const LibraryHomePage({super.key});

  final List<Map<String, String>> daftarBuku = const [
    {
      'judul': 'Pemrograman Mobile dengan Flutter',
      'penulis': 'Raka Pratama',
      'tersedia': '3 Buku',
      'tahun': '2025',
      'kategori': 'Teknologi',
      'deskripsi': 'Buku ini membahas dasar hingga praktik pembuatan aplikasi mobile menggunakan Flutter.',
      'sampul': 'assets/images/flutter.jpg',
    },
    {
      'judul': 'Dasar Pemrograman Dart',
      'penulis': 'Dimas Saputra',
      'tersedia': '5 Buku',
      'tahun': '2024',
      'kategori': 'Pemrograman',
      'deskripsi': 'Buku ini membahas dasar bahasa pemrograman Dart mulai dari konsep dasar hingga penerapannya.',
      'sampul': 'assets/images/dart.jpg',
    },
    {
      'judul': 'Perancangan UI/UX Modern',
      'penulis': 'Nabila Putri',
      'tersedia': '2 Buku',
      'tahun': '2025',
      'kategori': 'Desain',
      'deskripsi': 'Buku ini membahas prinsip dasar perancangan antarmuka dan pengalaman pengguna pada aplikasi.',
      'sampul': 'assets/images/uiux.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      appBar: AppBar(
        backgroundColor: const Color(0xff1769d1),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.menu_book_rounded),
            SizedBox(width: 10),
            Text(
              'Perpustakaan Kampus',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: daftarBuku.length,
        itemBuilder: (context, index) {
          final buku = daftarBuku[index];

          return _BukuCard(
            buku: buku,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailBukuPage(buku: buku),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _BukuCard extends StatelessWidget {
  final Map<String, String> buku;
  final VoidCallback onTap;

  const _BukuCard({required this.buku, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                buku['sampul']!,
                width: 90,
                height: 125,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    buku['judul']!,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    buku['penulis']!,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Tersedia: ${buku['tersedia']}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1769d1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Lihat Detail'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
