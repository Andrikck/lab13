import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:lab13/models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  // Гетер для отримання бази даних
  Future<Database> get database async {
    if (_database != null) return _database!; // Якщо база вже ініціалізована
    _database = await _initDatabase(); // Ініціалізація бази, якщо ще не була ініціалізована
    return _database!;
  }

  // Ініціалізація бази даних
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes.db');
    print("Шлях до бази даних: $path");  // Лог для перевірки шляху до бази даних
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      print("Створення таблиці в базі даних"); // Лог для перевірки, чи створюється таблиця
      await db.execute(
        'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT, date TEXT)',
      );
    });
  }

  // Метод для додавання нотатки
  Future<int> insertNote(Note note) async {
    final db = await database;
    print("Вставка нотатки: ${note.text}");  // Лог перед вставкою нотатки
    return await db.insert('notes', note.toMap());
  }

  // Метод для отримання нотаток з бази
  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes', orderBy: 'id DESC');

    print("Завантажено ${maps.length} нотаток з бази");  // Лог для перевірки завантажених нотаток

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }
}
