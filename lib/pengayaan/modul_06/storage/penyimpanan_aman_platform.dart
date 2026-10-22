import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'penyimpanan_aman.dart';

class PenyimpananAmanPlatform implements PenyimpananAman {
  final FlutterSecureStorage _penyimpanan;

  PenyimpananAmanPlatform([FlutterSecureStorage? penyimpanan])
    : _penyimpanan = penyimpanan ?? const FlutterSecureStorage();

  @override
  Future<void> tulis(String kunci, String nilai) =>
      _penyimpanan.write(key: kunci, value: nilai);

  @override
  Future<String?> baca(String kunci) => _penyimpanan.read(key: kunci);

  @override
  Future<void> hapus(String kunci) => _penyimpanan.delete(key: kunci);

  @override
  Future<String?> bacaMentah(String kunci) async {
    // Plugin tidak menyediakan pembacaan mentah lewat kontrak ini.
    return null;
  }
}
