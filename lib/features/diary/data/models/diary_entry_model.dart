import '../../domain/entities/diary_entry.dart';

class DiaryEntryModel extends DiaryEntry {
  const DiaryEntryModel({
    required DateTime date,
    required String text,
    required int emojiIndex,
    required double sliderValue,
    String? imagePath,
  }) : super(
          date: date,
          text: text,
          emojiIndex: emojiIndex,
          sliderValue: sliderValue,
          imagePath: imagePath,
        );

  factory DiaryEntryModel.fromJson(Map<String, dynamic> json) {
    return DiaryEntryModel(
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      text: json['text'],
      emojiIndex: json['emojiIndex'],
      sliderValue: (json['sliderValue'] as num).toDouble(),
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.millisecondsSinceEpoch,
      'text': text,
      'emojiIndex': emojiIndex,
      'sliderValue': sliderValue,
      'imagePath': imagePath,
    };
  }

  factory DiaryEntryModel.fromEntity(DiaryEntry entry) {
    return DiaryEntryModel(
      date: entry.date,
      text: entry.text,
      emojiIndex: entry.emojiIndex,
      sliderValue: entry.sliderValue,
      imagePath: entry.imagePath,
    );
  }
}
