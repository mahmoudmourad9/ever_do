import 'package:flutter/material.dart';

class MoodCard extends StatelessWidget {
  final int selectedEmoji;
  final double sliderValue;
  final Function(int) onEmojiSelected;
  final Function(double) onSliderChanged;

  const MoodCard({
    super.key,
    required this.selectedEmoji,
    required this.sliderValue,
    required this.onEmojiSelected,
    required this.onSliderChanged,
  });

  String _emojiFromIndex(int i) {
    const list = ['😡', '☹️', '🙂', '😄', '😍'];
    if (i < 0 || i >= list.length) return '🙂';
    return list[i];
  }

  @override
  Widget build(BuildContext context) {
    final Color cardColor = Theme.of(context).cardColor;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
        child: Column(
          children: [
            // صف الإيموجي
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () => onEmojiSelected(i),
                  child: Opacity(
                    opacity: selectedEmoji == i ? 1.0 : 0.5,
                    child: Text(
                      _emojiFromIndex(i),
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 10),

            // السلايدر
            Slider(
              value: sliderValue,
              activeColor: Theme.of(context).primaryColor,
              onChanged: onSliderChanged,
            ),

            const SizedBox(height: 5),

            // عرض الإيموجي المختار
            Text(
              'المزاج الحالي: ${_emojiFromIndex(selectedEmoji)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
