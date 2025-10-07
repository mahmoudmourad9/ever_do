class Note {
  String title;
  String text;
  DateTime date;

  Note({
    required this.title,
    required this.text,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'text': text,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      text: map['text'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }
}
