import 'package:everdo_app/screen/settings_screen.dart';
import 'package:flutter/material.dart';

class costmAppbar extends StatelessWidget {
  const costmAppbar({
    super.key,
    required this.titel,
   
  });

  final String titel;
  

  get onThemeChanged => null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF006C8D),
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      onThemeChanged: onThemeChanged,
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            titel,
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'UthmanTNB'),
          ),
          Row(
            children: [
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: const Color(0xFF006C8D),
                child: Image.asset('assets/images/logo_bar.png')
              ),
            ],
          ),
        ],
      ),
    );
  }
}
