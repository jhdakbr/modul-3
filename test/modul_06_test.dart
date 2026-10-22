import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:modul3/modul_06/models/sesi_pengguna.dart';
import 'package:modul3/modul_06/screens/login_screen.dart';
import 'package:modul3/modul_06/services/auth_api.dart';
import 'package:modul3/modul_06/services/sesi_memori.dart';
import 'package:modul3/modul_06/widgets/kartu_sesi.dart';

/// API tiruan yang menghitung berapa kali masuk() dipanggil.
class _ApiPenghitung extends AuthApi {
  int panggilan = 0;

  _ApiPenghitung({super.tunda});

  @override
  Future<SesiPengguna> masuk({
    required String email,
    required String sandi,
    Duration masaBerlaku = const Duration(hours: 2),
  }) {
    panggilan++;
    return super.masuk(email: email, sandi: sandi, masaBerlaku: masaBerlaku);
  }
}

const AuthApi _apiCepat = AuthApi(tunda: Duration.zero);

Future<void> _pasangLayar(
  WidgetTester tester, {
  AuthApi? api,
  SesiMemori? memori,
  DateTime Function()? jam,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: LoginScreen(
        api: api ?? _apiCepat,
        sesiMemori: memori ?? SesiMemori(),
        jam: jam ?? DateTime.now,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _isiForm(
  WidgetTester tester, {
  required String email,
  required String sandi,
}) async {
  await tester.enterText(find.byType(TextFormField).at(0), email);
  await tester.enterText(find.byType(TextFormField).at(1), sandi);
}

void main() {
  group('Fase A - SesiPengguna', () {
    test('toJson lalu fromJson menghasilkan data yang sama', () {
      final SesiPengguna asli = SesiPengguna.contoh();
      final SesiPengguna salinan = SesiPengguna.fromJson(asli.toJson());
      expect(salinan.token, asli.token);
      expect(salinan.email, asli.email);
      expect(salinan.kedaluwarsaPada, asli.kedaluwarsaPada);
    });

    test('fromJson memakai nilai cadangan untuk kunci yang hilang', () {
      final SesiPengguna s = SesiPengguna.fromJson(<String, dynamic>{});
      expect(s.token, '');
      expect(s.email, 'tanpa-email');
      expect(s.nama, 'Pengguna');
      expect(s.peran, 'mahasiswa');
    });

    test('sudahKedaluwarsa: sebelum, tepat di batas, dan sesudah', () {
      final SesiPengguna s = SesiPengguna.contoh(); // 08:00 + 2 jam
      expect(s.sudahKedaluwarsa(DateTime(2026, 9, 21, 9)), isFalse);
      expect(s.sudahKedaluwarsa(DateTime(2026, 9, 21, 10)), isTrue);
      expect(s.sudahKedaluwarsa(DateTime(2026, 9, 21, 11)), isTrue);
    });

    test('tanggal rusak dianggap kedaluwarsa', () {
      const SesiPengguna s = SesiPengguna(
        token: 't',
        email: 'a@b.c',
        nama: 'A',
        peran: 'mahasiswa',
        masukPada: 'rusak',
        kedaluwarsaPada: 'rusak',
      );
      expect(s.sudahKedaluwarsa(DateTime(2026, 9, 21)), isTrue);
      expect(s.sisaWaktu(DateTime(2026, 9, 21)), Duration.zero);
    });

    test('sisaWaktu menghitung selisih dan tidak pernah negatif', () {
      final SesiPengguna s = SesiPengguna.contoh();
      expect(s.sisaWaktu(DateTime(2026, 9, 21, 8)), const Duration(hours: 2));
      expect(s.sisaWaktu(DateTime(2026, 9, 21, 11)), Duration.zero);
    });

    test('labelPeran', () {
      expect(SesiPengguna.labelPeran('dosen'), 'Dosen');
      expect(SesiPengguna.labelPeran('mahasiswa'), 'Mahasiswa');
      expect(SesiPengguna.labelPeran('lain'), 'Pengguna');
    });
  });

  group('Fase A - AuthApi', () {
    test('kredensial demo berhasil dan menghasilkan token dummy', () async {
      final SesiPengguna s = await _apiCepat.masuk(
        email: AuthApi.emailDemo,
        sandi: AuthApi.sandiDemo,
      );
      expect(s.email, AuthApi.emailDemo);
      expect(s.nama, 'Mahasiswa TRPL');
      expect(s.token.startsWith('dummy.'), isTrue);
    });

    test('email dinormalisasi (spasi dan huruf besar)', () async {
      final SesiPengguna s = await _apiCepat.masuk(
        email: '  STUDENT@trpl.test ',
        sandi: AuthApi.sandiDemo,
      );
      expect(s.email, AuthApi.emailDemo);
    });

    test('sandi salah -> AuthException 401', () async {
      await expectLater(
        _apiCepat.masuk(email: AuthApi.emailDemo, sandi: 'salahsalah'),
        throwsA(
          isA<AuthException>().having((AuthException e) => e.kode, 'kode', 401),
        ),
      );
    });

    test('akun terkunci -> 423', () async {
      await expectLater(
        _apiCepat.masuk(email: AuthApi.emailTerkunci, sandi: 'apasaja123'),
        throwsA(
          isA<AuthException>().having((AuthException e) => e.kode, 'kode', 423),
        ),
      );
    });

    test('server gangguan -> 503', () async {
      await expectLater(
        _apiCepat.masuk(
          email: AuthApi.emailServerGangguan,
          sandi: 'apasaja123',
        ),
        throwsA(
          isA<AuthException>().having((AuthException e) => e.kode, 'kode', 503),
        ),
      );
    });

    test('kolom kosong -> 400', () async {
      await expectLater(
        _apiCepat.masuk(email: '', sandi: ''),
        throwsA(
          isA<AuthException>().having((AuthException e) => e.kode, 'kode', 400),
        ),
      );
    });

    test('pesan tidak membocorkan apakah email terdaftar', () async {
      String? pesanA;
      String? pesanB;
      try {
        await _apiCepat.masuk(
          email: 'tidak-ada@trpl.test',
          sandi: 'belajar123',
        );
      } on AuthException catch (e) {
        pesanA = e.pesan;
      }
      try {
        await _apiCepat.masuk(email: AuthApi.emailDemo, sandi: 'salahsalah');
      } on AuthException catch (e) {
        pesanB = e.pesan;
      }
      expect(pesanA, isNotNull);
      expect(pesanA, pesanB);
    });
  });

  group('Fase A - SesiMemori', () {
    test('simpan, baca, hapus', () async {
      final SesiMemori m = SesiMemori();
      expect(m.baca(), isNull);
      expect(m.adaSesi, isFalse);

      await m.simpan(SesiPengguna.contoh());
      expect(m.adaSesi, isTrue);
      expect(m.baca()?.email, 'student@trpl.test');
      expect(m.jumlahPenulisan, 1);

      await m.hapus();
      expect(m.baca(), isNull);
    });
  });

  group('Fase A - KartuSesi (fungsi bantu)', () {
    test('samarkanToken', () {
      expect(KartuSesi.samarkanToken(''), '(kosong)');
      expect(KartuSesi.samarkanToken('abc'), '\u2022' * 3);
      expect(KartuSesi.samarkanToken('abcdef123456'), 'abcdef${'\u2022' * 12}');
    });

    test('formatSisa', () {
      expect(KartuSesi.formatSisa(Duration.zero), 'sudah berakhir');
      expect(KartuSesi.formatSisa(const Duration(seconds: 45)), '45 detik');
      expect(KartuSesi.formatSisa(const Duration(minutes: 30)), '30 menit');
      expect(KartuSesi.formatSisa(const Duration(hours: 2)), '2 jam');
      expect(
        KartuSesi.formatSisa(const Duration(hours: 1, minutes: 5)),
        '1 jam 5 menit',
      );
    });

    test('formatWaktu', () {
      expect(
        KartuSesi.formatWaktu('2026-09-21T10:15:00.000'),
        '21 Sep 2026, 10:15',
      );
      expect(KartuSesi.formatWaktu('rusak'), 'tidak diketahui');
    });
  });

  group('Fase A - LoginScreen', () {
    testWidgets('awal: form tampil tanpa pesan kesalahan (keluar != gagal)', (
      WidgetTester tester,
    ) async {
      await _pasangLayar(tester);
      expect(find.text('Masuk ke Portal Akademik'), findsOneWidget);
      expect(find.text('Email atau kata sandi salah.'), findsNothing);
    });

    testWidgets('validator menolak kolom kosong dan API tidak dipanggil', (
      WidgetTester tester,
    ) async {
      final _ApiPenghitung api = _ApiPenghitung(tunda: Duration.zero);
      await _pasangLayar(tester, api: api);

      await tester.tap(find.text('Masuk'));
      await tester.pump();

      expect(find.text('Email wajib diisi.'), findsOneWidget);
      expect(find.text('Kata sandi wajib diisi.'), findsOneWidget);
      expect(api.panggilan, 0);
    });

    testWidgets('login berhasil menampilkan beranda dan menyimpan sesi', (
      WidgetTester tester,
    ) async {
      final SesiMemori memori = SesiMemori();
      await _pasangLayar(tester, memori: memori);

      await _isiForm(
        tester,
        email: AuthApi.emailDemo,
        sandi: AuthApi.sandiDemo,
      );
      await tester.tap(find.text('Masuk'));
      await tester.pumpAndSettle();

      expect(find.text('Beranda'), findsOneWidget);
      expect(memori.adaSesi, isTrue);
    });

    testWidgets('login gagal menampilkan pesan dari AuthApi', (
      WidgetTester tester,
    ) async {
      final SesiMemori memori = SesiMemori();
      await _pasangLayar(tester, memori: memori);

      await _isiForm(tester, email: AuthApi.emailDemo, sandi: 'salahsalah');
      await tester.tap(find.text('Masuk'));
      await tester.pumpAndSettle();

      expect(find.text('Email atau kata sandi salah.'), findsOneWidget);
      expect(memori.adaSesi, isFalse);
    });

    testWidgets(
      'tombol mati saat memproses: ketukan kedua tidak mengirim ulang',
      (WidgetTester tester) async {
        final _ApiPenghitung api = _ApiPenghitung(
          tunda: const Duration(seconds: 1),
        );
        await _pasangLayar(tester, api: api);

        await _isiForm(
          tester,
          email: AuthApi.emailDemo,
          sandi: AuthApi.sandiDemo,
        );
        await tester.tap(find.text('Masuk'));
        await tester.pump();

        expect(find.text('Memproses…'), findsOneWidget);
        await tester.tap(find.text('Memproses…'), warnIfMissed: false);
        await tester.pump();

        await tester.pumpAndSettle(const Duration(seconds: 2));
        expect(api.panggilan, 1);
      },
    );

    testWidgets('logout kembali ke form tanpa pesan gagal', (
      WidgetTester tester,
    ) async {
      final SesiMemori memori = SesiMemori();
      await _pasangLayar(tester, memori: memori);

      await _isiForm(
        tester,
        email: AuthApi.emailDemo,
        sandi: AuthApi.sandiDemo,
      );
      await tester.tap(find.text('Masuk'));
      await tester.pumpAndSettle();

      final Finder tombolKeluar = find.text('Keluar');
      await tester.ensureVisible(tombolKeluar);
      await tester.tap(tombolKeluar);
      await tester.pumpAndSettle();

      expect(find.text('Masuk ke Portal Akademik'), findsOneWidget);
      expect(find.text('Email atau kata sandi salah.'), findsNothing);
      expect(memori.adaSesi, isFalse);
    });

    testWidgets('sesi tersimpan yang masih berlaku dipulihkan ke beranda', (
      WidgetTester tester,
    ) async {
      final SesiMemori memori = SesiMemori();
      await memori.simpan(SesiPengguna.contoh()); // berlaku sampai 10:00
      await _pasangLayar(
        tester,
        memori: memori,
        jam: () => DateTime(2026, 9, 21, 9),
      );
      expect(find.text('Beranda'), findsOneWidget);
    });

    testWidgets('sesi kedaluwarsa dibuang dan pengguna diminta masuk lagi', (
      WidgetTester tester,
    ) async {
      final SesiMemori memori = SesiMemori();
      await memori.simpan(SesiPengguna.contoh());
      await _pasangLayar(
        tester,
        memori: memori,
        jam: () => DateTime(2026, 9, 21, 12),
      );
      expect(
        find.text('Sesi sebelumnya sudah berakhir. Silakan masuk lagi.'),
        findsOneWidget,
      );
      expect(memori.adaSesi, isFalse);
    });
  });
}
