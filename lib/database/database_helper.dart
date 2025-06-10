import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tugas13_flutter/model/buku_model.dart';

class DatabaseHelper {
  static const _databaseName = 'book_manager.db';
  static const _databaseVersion = 1;

  static const tableBook = 'books';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableBook (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        description TEXT
      )
    ''');
  }

  // Insert book
  Future<int> insertBook(BookModel book) async {
    final db = await database;
    return await db.insert(tableBook, book.toMap());
  }

  // Get all books
  Future<List<BookModel>> getBooks() async {
    final db = await database;
    final maps = await db.query(tableBook, orderBy: 'id DESC');

    return maps.map((map) => BookModel.fromMap(map)).toList();
  }

  // Update book
  Future<int> updateBook(BookModel book) async {
    final db = await database;
    return await db.update(
      tableBook,
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  // Delete book
  Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete(tableBook, where: 'id = ?', whereArgs: [id]);
  }

  // Get a single book by ID (optional)
  Future<BookModel?> getBookById(int id) async {
    final db = await database;
    final maps = await db.query(tableBook, where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return BookModel.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
