import 'package:flutter/foundation.dart';

import '../../../modul_06/models/sesi_pengguna.dart';
import '../../../modul_06/services/auth_api.dart';
import '../repositories/sesi_repository.dart';

enum StatusSesi { memeriksa, keluar, memproses, masuk, gagal, kedaluwarsa }

class SesiController extends ChangeNotifier {
  final AuthApi api;
  final DateTime Function() jam;
  SesiRepository _repository;

  SesiController({
    required this.api,
    required this._repository,
    DateTime Function()? jam,
  }) : jam = jam ?? DateTime.now;

  StatusSesi _status = StatusSesi.memeriksa;
  SesiPengguna? _sesi;
  String? _pesan;
  bool _dibuang = false;

  SesiRepository get repository => _repository;
  StatusSesi get status => _status;
  SesiPengguna? get sesi => _sesi;
  String? get pesan => _pesan;

  void _ubah(StatusSesi status, {String? pesan}) {
    _status = status;
    _pesan = pesan;
    if (!_dibuang) notifyListeners();
  }

  @override
  void dispose() {
    _dibuang = true;
    super.dispose();
  }

  Future<void> pulihkan() async {
    _ubah(StatusSesi.memeriksa);

    final SesiPengguna? tersimpan = await _repository.baca();
    if (tersimpan == null) {
      _sesi = null;
      _ubah(StatusSesi.keluar);
      return;
    }

    if (tersimpan.sudahKedaluwarsa(jam())) {
      await _repository.hapus(); // Sesi mati dibuang, bukan dibiarkan.
      _sesi = null;
      _ubah(
        StatusSesi.kedaluwarsa,
        pesan: 'Sesi Anda sudah berakhir. Silakan masuk kembali.',
      );
      return;
    }

    _sesi = tersimpan;
    _ubah(StatusSesi.masuk);
  }

  Future<void> masuk({required String email, required String sandi}) async {
    if (_status == StatusSesi.memproses) return; // Cegah kirim ganda.
    _ubah(StatusSesi.memproses);

    try {
      final SesiPengguna hasil = await api.masuk(email: email, sandi: sandi);
      await _repository.simpan(hasil);
      _sesi = hasil;
      _ubah(StatusSesi.masuk);
    } on AuthException catch (e) {
      _sesi = null;
      _ubah(StatusSesi.gagal, pesan: e.pesan);
    } catch (e) {
      _sesi = null;
      debugPrint('Login gagal tak terduga: $e');
      _ubah(
        StatusSesi.gagal,
        pesan: 'Terjadi kesalahan tak terduga. Coba lagi.',
      );
    }
  }

  Future<void> perbaruiSesi({
    Duration masaBerlaku = const Duration(hours: 2),
  }) async {
    final SesiPengguna? sekarang = _sesi;
    if (sekarang == null) return;

    if (sekarang.sudahKedaluwarsa(jam())) {
      await _repository.hapus();
      _sesi = null;
      _ubah(
        StatusSesi.kedaluwarsa,
        pesan: 'Sesi sudah berakhir dan tidak dapat diperbarui.',
      );
      return;
    }

    final SesiPengguna baru = await api.perbaruiSesi(
      sekarang,
      masaBerlaku: masaBerlaku,
    );
    await _repository.simpan(baru);
    _sesi = baru;
    _ubah(StatusSesi.masuk);
  }

  Future<void> keluar() async {
    await _repository.hapus();
    _sesi = null;
    _ubah(StatusSesi.keluar);
  }

  /// Berpindah penyimpanan TIDAK memindahkan sesi lama.
  Future<void> gantiPenyimpanan(SesiRepository baru) async {
    _repository = baru;
    _sesi = null;
    await pulihkan();
  }
}
