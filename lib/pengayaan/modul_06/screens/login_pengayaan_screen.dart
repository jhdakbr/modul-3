import 'package:flutter/material.dart';

import '../../../modul_06/services/auth_api.dart';
import '../../../modul_06/widgets/field_kata_sandi.dart';
import '../controllers/sesi_controller.dart';
import '../repositories/sesi_repository.dart';

class LoginPengayaanScreen extends StatefulWidget {
  final SesiController controller;
  final List<SesiRepository> pilihan;

  const LoginPengayaanScreen({
    super.key,
    required this.controller,
    required this.pilihan,
  });

  @override
  State<LoginPengayaanScreen> createState() => _LoginPengayaanScreenState();
}

class _LoginPengayaanScreenState extends State<LoginPengayaanScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _sandi = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _sandi.dispose();
    super.dispose();
  }

  Future<void> _kirim() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await widget.controller.masuk(email: _email.text, sandi: _sandi.text);
  }

  @override
  Widget build(BuildContext context) {
    final SesiController k = widget.controller;
    final bool sibuk = k.status == StatusSesi.memproses;
    final ColorScheme c = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        const Text(
          'Masuk (Fase B)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text('Penyimpanan sesi:'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: <Widget>[
            for (final SesiRepository r in widget.pilihan)
              ChoiceChip(
                label: Text(r.nama),
                selected: identical(r, k.repository),
                onSelected: sibuk ? null : (_) => k.gantiPenyimpanan(r),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          k.repository.keterangan,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        if (k.pesan != null) ...<Widget>[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: c.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(k.pesan!, style: TextStyle(color: c.onErrorContainer)),
          ),
          const SizedBox(height: 16),
        ],
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _email,
                enabled: !sibuk,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                validator: (String? v) {
                  final String t = (v ?? '').trim();
                  if (t.isEmpty) return 'Email wajib diisi.';
                  if (!t.contains('@') || !t.contains('.')) {
                    return 'Format email belum benar.';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              FieldKataSandi(
                controller: _sandi,
                enabled: !sibuk,
                validator: (String? v) {
                  if (v == null || v.isEmpty) return 'Kata sandi wajib diisi.';
                  if (v.length < 8) return 'Kata sandi minimal 8 karakter.';
                  return null;
                },
                onSubmitted: _kirim,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 48,
          child: FilledButton(
            onPressed: sibuk ? null : _kirim,
            child: Text(sibuk ? 'Memproses…' : 'Masuk'),
          ),
        ),
        TextButton(
          onPressed: sibuk
              ? null
              : () => setState(() {
                  _email.text = AuthApi.emailDemo;
                  _sandi.text = AuthApi.sandiDemo;
                }),
          child: const Text('Isi otomatis akun demo'),
        ),
      ],
    );
  }
}
