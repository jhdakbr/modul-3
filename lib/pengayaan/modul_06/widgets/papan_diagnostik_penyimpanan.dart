import 'package:flutter/material.dart';

import '../repositories/sesi_repository.dart';

class PapanDiagnostikPenyimpanan extends StatefulWidget {
  final SesiRepository repository;
  const PapanDiagnostikPenyimpanan({super.key, required this.repository});

  @override
  State<PapanDiagnostikPenyimpanan> createState() =>
      _PapanDiagnostikPenyimpananState();
}

class _PapanDiagnostikPenyimpananState
    extends State<PapanDiagnostikPenyimpanan> {
  String? _hasilIntip;
  bool _sudahMengintip = false;
  bool _sedangMengintip = false;

  Future<void> _intip() async {
    setState(() => _sedangMengintip = true);
    final String? hasil = await widget.repository.intipMentah();
    if (!mounted) return;
    setState(() {
      _hasilIntip = hasil;
      _sudahMengintip = true;
      _sedangMengintip = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final SesiRepository repo = widget.repository;
    final ColorScheme c = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Diagnostik penyimpanan: ${repo.nama}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(repo.keterangan),
            const SizedBox(height: 4),
            Text(
              'Bertahan setelah restart: '
              '${repo.bertahanSetelahRestart ? "ya" : "tidak"}',
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _sedangMengintip ? null : _intip,
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('Intip data mentah'),
            ),
            if (_sudahMengintip) ...<Widget>[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: c.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  _hasilIntip ??
                      '(tidak ada nilai yang dapat dibaca lewat API ini)',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
