import '../../domain/entities/note.dart';

class NoteModel extends Note {
  const NoteModel({
    required String title,
    required String text,
    required DateTime date,
  }) : super(title: title, text: text, date: date);

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      title: json['title'],
      text: json['text'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'text': text,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      title: note.title,
      text: note.text,
      date: note.date,
    );
  }
}
