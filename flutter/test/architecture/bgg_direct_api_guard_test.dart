import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BGG 연동은 bgcut Bgmate BGG wrapper를 호출하지 않는다', () {
    final offenders = <String>[];

    for (final file in Directory('lib').listSync(recursive: true)) {
      if (file is! File || !file.path.endsWith('.dart')) continue;
      final text = file.readAsStringSync();
      if (text.contains('/api/bgmate/bgg-')) offenders.add(file.path);
    }

    expect(offenders, isEmpty);
  });
}
