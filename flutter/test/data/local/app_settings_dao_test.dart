import 'package:bgmate_flutter/data/local/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('설정값을 삭제하면 다시 null로 조회된다', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await db.appSettingsDao.setValue('bgg_username', 'kurt');
    await db.appSettingsDao.deleteValue('bgg_username');

    expect(await db.appSettingsDao.getValue('bgg_username'), isNull);
  });
}
