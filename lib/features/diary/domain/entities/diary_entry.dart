class DiaryEntry {
  final DateTime date;
  final String text;
  final int emojiIndex;
  final double sliderValue;
  final String? imagePath;

  const DiaryEntry({
    required this.date,
    required this.text,
    required this.emojiIndex,
    required this.sliderValue,
    this.imagePath,
  });
}
