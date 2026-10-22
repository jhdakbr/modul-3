import 'dart:convert';

import '../../../modul_06/models/sesi_pengguna.dart';
import '../storage/penyimpanan_aman.dart';
import 'sesi_repository.dart';

class AmanSesiRepository implements SesiRepository {
  static const String kunciSesi = 'modul06.sesi';

  final PenyimpananAman penyimpanan;
  AmanSesiRepository(this.penyimpanan);

  @override
  String get nama => 'Aman';
  @override
  String get keterangan =>
      'Secure storage: perlindungan aktual mengikuti platform dan konfigurasi.';
  @override
  bool get bertahanSetelahRestart => true;

  @override
  Future<SesiPengguna?> baca() async {
    final String? mentah = await penyimpanan.baca(kunciSesi);
    if (mentah == null) return null;
    try {
      return SesiPengguna.fromJson(jsonDecode(mentah) as Map<String, dynamic>);
    } on FormatException {
      await penyimpanan.hapus(kunciSesi);
      return null;
    } on TypeError {
      await penyimpanan.hapus(kunciSesi);
      return null;
    }
  }

  @override
  Future<void> simpan(SesiPengguna sesi) =>
      penyimpanan.tulis(kunciSesi, jsonEncode(sesi.toJson()));

  @override
  Future<void> hapus() => penyimpanan.hapus(kunciSesi);

  @override
  Future<bool> adaSesi() async => (await baca()) != null;

  @override
  Future<String?> intipMentah() => penyimpanan.bacaMentah(kunciSesi);
}
