// ignore: file_names
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final bool isDarkMode;
  final Color textColor;

  const EmptyState({super.key, required this.isDarkMode, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            isDarkMode
                ? 'assets/images/notes_white.png'
                : 'assets/images/notes.png',
            height: 120,
          ),
          const SizedBox(height: 10),
          Text(
            'لا يوجد ملاحظات',
            style: TextStyle(
                fontSize: 20,
                // ignore: deprecated_member_use
                color: textColor.withOpacity(0.6),
                fontFamily: 'Tajawal'),  
          ),
        ],
      ),
    );
  }
}