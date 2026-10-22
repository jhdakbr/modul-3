import 'package:flutter/material.dart';

import 'modul_06/modul_06_app.dart';
import 'pengayaan/modul_06/modul_06_pengayaan_app.dart';

const bool _pengayaan = bool.fromEnvironment('PENGAYAAN');

void main() =>
    runApp(_pengayaan ? const Modul06PengayaanApp() : const Modul06App());
