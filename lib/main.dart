import 'package:flutter/material.dart';

import 'perpustakaan/library_home_page.dart';

void main() {
  runApp(const Modul3App());
}

class Modul3App extends StatelessWidget {
  const Modul3App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Perpustakaan Kampus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff1769d1)),
        useMaterial3: true,
      ),
      home: const LibraryHomePage(),
    );
  }
}
