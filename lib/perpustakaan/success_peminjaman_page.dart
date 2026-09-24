import 'package:flutter/material.dart';

class SuccessPeminjamanPage extends StatelessWidget {
  final Map<String, String> buku;

  const SuccessPeminjamanPage({super.key, required this.buku});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      appBar: AppBar(
        backgroundColor: const Color(0xff1769d1),
        foregroundColor: Colors.white,
        title: const Text(
          'Peminjaman Buku',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 90,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Peminjaman Berhasil!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              'Buku "${buku['judul']}" berhasil dipinjam.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),

            const SizedBox(height: 28),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _InfoPeminjaman(
                    icon: Icons.calendar_month,
                    title: 'Tanggal Pinjam',
                    value: '24 September 2026',
                  ),

                  const SizedBox(height: 20),

                  _InfoPeminjaman(
                    icon: Icons.access_time,
                    title: 'Batas Pengembalian',
                    value: '31 September 2026',
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.home),
                label: const Text(
                  'Kembali ke Beranda',
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
          ],
        ),
      ),
    );
  }
}

class _InfoPeminjaman extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoPeminjaman({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xff1769d1), size: 25),

        const SizedBox(width: 14),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 4),

            Text(value),
          ],
        ),
      ],
    );
  }
}
