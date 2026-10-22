import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../modul_06/models/sesi_pengguna.dart';
import 'sesi_repository.dart';

class PrefsSesiRepository implements SesiRepository {
  static const String kunciSesi = 'modul06.sesi';

  final Future<SharedPreferences> _prefs;
  PrefsSesiRepository([Future<SharedPreferences>? prefs])
    : _prefs = prefs ?? SharedPreferences.getInstance();

  @override
  String get nama => 'Prefs';
  @override
  String get keterangan =>
      'SharedPreferences: bertahan, tetapi token tersimpan apa adanya.';
  @override
  bool get bertahanSetelahRestart => true;

  @override
  Future<SesiPengguna?> baca() async {
    final SharedPreferences prefs = await _prefs;
    final String? mentah = prefs.getString(kunciSesi);
    if (mentah == null) return null;
    try {
      return SesiPengguna.fromJson(jsonDecode(mentah) as Map<String, dynamic>);
    } on FormatException {
      await prefs.remove(kunciSesi);
      return null;
    } on TypeError {
      await prefs.remove(kunciSesi);
      return null;
    }
  }

  @override
  Future<void> simpan(SesiPengguna sesi) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(kunciSesi, jsonEncode(sesi.toJson()));
  }

  @override
  Future<void> hapus() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(kunciSesi);
  }

  @override
  Future<bool> adaSesi() async => (await baca()) != null;

  @override
  Future<String?> intipMentah() async {
    final SharedPreferences prefs = await _prefs;
    // Adapter preferensi mengembalikan nilai token lewat API biasa.
    return prefs.getString(kunciSesi);
  }
}
