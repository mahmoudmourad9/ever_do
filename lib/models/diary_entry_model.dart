class DiaryEntry {
  DateTime date;
  String text;
  int emojiIndex;
  double sliderValue;
  String? imagePath;

  DiaryEntry({
    required this.date,
    required this.text,
    required this.emojiIndex,
    required this.sliderValue,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.millisecondsSinceEpoch,
      'text': text,
      'emojiIndex': emojiIndex,
      'sliderValue': sliderValue,
      'imagePath': imagePath,
    };
  }

  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      text: map['text'],
      emojiIndex: map['emojiIndex'],
      sliderValue: (map['sliderValue'] as num).toDouble(),
      imagePath: map['imagePath'],
    );
  }
}