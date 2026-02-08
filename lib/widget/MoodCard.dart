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
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: cardColor.withOpacity(0.8), // Glass effect base
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          children: [
            // Emoji Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (i) {
                final isSelected = selectedEmoji == i;
                return GestureDetector(
                  onTap: () => onEmojiSelected(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    transform: Matrix4.identity()
                      ..scale(isSelected ? 1.4 : 1.0),
                    child: Opacity(
                      opacity: isSelected ? 1.0 : 0.4,
                      child: Text(
                        _emojiFromIndex(i),
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            // Slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: primaryColor,
                inactiveTrackColor: primaryColor.withOpacity(0.2),
                thumbColor: primaryColor,
                overlayColor: primaryColor.withOpacity(0.1),
                trackHeight: 6,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              ),
              child: Slider(
                value: sliderValue,
                onChanged: onSliderChanged,
              ),
            ),

            const SizedBox(height: 5),

            // Selected Mood Text
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.5),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Text(
                'المزاج الحالي: ${_emojiFromIndex(selectedEmoji)}',
                key: ValueKey<int>(selectedEmoji),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
