import 'package:flutter/material.dart';
import 'package:lab13/helpers/database_helper.dart';
import 'package:lab13/models/note.dart';
import 'package:intl/intl.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // Завантаження нотаток з БД
  void _loadNotes() async {
    final notes = await DatabaseHelper().getNotes();
    setState(() {
      _notes = notes; // Оновлюємо список нотаток після отримання їх з БД
    });

    // Виведення нотаток у консоль для перевірки
    for (var note in notes) {
      print("Завантажено: ${note.text}, Дата: ${note.date}");
    }
  }

  // Додавання нової нотатки
  void _addNote() async {
    if (_controller.text.isEmpty) {
      return; // Не додаємо пусті нотатки
    }

    final newNote = Note(
      text: _controller.text,
      date: DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now()), // Поточна дата та час
    );

    await DatabaseHelper().insertNote(newNote); // Додавання нотатки в базу
    _controller.clear(); // Очистити поле вводу
    _loadNotes(); // Оновити список нотаток
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Збереження нотаток'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Поле для введення нотатки
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Введіть нотатку',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Кнопка для додавання нотатки
            ElevatedButton(
              onPressed: _addNote,
              child: Text('Додати нотатку'),
            ),
            SizedBox(height: 20),
            // Список нотаток
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return ListTile(
                    title: Text(note.text),
                    subtitle: Text(note.date),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
