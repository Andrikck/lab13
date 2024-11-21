class Note {
  final int? id;
  final String text;
  final String date;

  Note({
    this.id,
    required this.text,
    required this.date,
  });

  // Перетворення нотатки в Map для збереження в БД
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'date': date,
    };
  }

  // Створення нотатки з Map після завантаження з БД
  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      text: map['text'],
      date: map['date'],
    );
  }
}
