import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WishlistDatabase {
  static Database? _database;
  static const _tableName = 'wishlist';
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnImage = 'image';
  static const columnMealId = 'mealid';

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'wishlist.db');

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $_tableName (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnTitle TEXT,
          $columnImage TEXT,
          $columnMealId REAL
        )
        ''');
      },
    );
  }

  static Future<void> addToWishlist({
    required String title,
    required String image,
    required String mealid,
  }) async {
    final db = await database;
    await db.insert(
      _tableName,
      {
        columnTitle: title,
        columnImage: image,
        columnMealId: mealid,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  static Future<void> removeFromWishlist(String title) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: '$columnTitle = ?',
      whereArgs: [title],
    );
  }

  static Future<List<Map<String, dynamic>>> getWishlistItems() async {
    final db = await database;
    return db.query(_tableName);
  }
}
