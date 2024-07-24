import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// import 'package:path/path.dart';

class SQLMatkul {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE data(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nama_mata_kuliah TEXT,
    kode_mata_kuliah TEXT,
    jadwal_kuliah TEXT
  )""");
  }

  static Future<sql.Database> db() async {
    // Ensure proper initialization of sqflite_common_ffi
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    return sql.openDatabase("course.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<int> createData(
      String item, String? kode, String jadwal) async {
    final db = await SQLMatkul.db();
    final data = {
      'nama_mata_kuliah': item,
      'kode_mata_kuliah': kode,
      'jadwal_kuliah': jadwal
    };
    final id = await db.insert('data', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await SQLMatkul.db();
    return db.query('data', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getSigleData(int id) async {
    final db = await SQLMatkul.db();
    return db.query('data', where: "id = ? ", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(
      int id, String nama, String? kode, String jadwal) async {
    final db = await SQLMatkul.db();
    final data = {
      'nama_mata_kuliah': nama,
      'kode_mata_kuliah': kode,
      'jadwal_kuliah': jadwal
    };
    final result =
        await db.update('data', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await SQLMatkul.db();
    try {
      await db.delete('data', where: "id = ? ", whereArgs: [id]);

      // ignore: empty_catches
    } catch (e) {}
  }
}
