import 'package:flutter/material.dart';

import 'success_peminjaman_page.dart';

class DetailBukuPage extends StatelessWidget {
  final Map<String, String> buku;

  const DetailBukuPage({super.key, required this.buku});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      appBar: AppBar(
        backgroundColor: const Color(0xff1769d1),
        foregroundColor: Colors.white,
        title: const Text(
          'Detail Buku',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  buku['sampul']!,
                  width: 190,
                  height: 260,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 22),

            Text(
              buku['judul']!,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 18),

            _InfoBuku(
              icon: Icons.person,
              label: 'Penulis',
              value: buku['penulis']!,
            ),

            _InfoBuku(
              icon: Icons.calendar_month,
              label: 'Tahun Terbit',
              value: buku['tahun']!,
            ),

            _InfoBuku(
              icon: Icons.category,
              label: 'Kategori',
              value: buku['kategori']!,
            ),

            _InfoBuku(
              icon: Icons.description,
              label: 'Deskripsi',
              value: buku['deskripsi']!,
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Tersedia: ${buku['tersedia']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SuccessPeminjamanPage(buku: buku),
                    ),
                  );
                },
                icon: const Icon(Icons.menu_book),
                label: const Text(
                  'Pinjam Buku',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1769d1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xff1769d1),
                  side: const BorderSide(color: Color(0xff1769d1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Kembali', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBuku extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoBuku({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xff1769d1), size: 22),

          const SizedBox(width: 12),

          SizedBox(
            width: 95,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          const Text(': '),

          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
