import 'package:flutter/material.dart';

class costmAppbar extends StatelessWidget {
  const costmAppbar({
    super.key,
     required this.titel, required this.rightIcon,
  });

  
  final String titel;
  final IconData? rightIcon;
 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF006C8D),
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                
              },
            ),
          ),
           Text(
            titel,
            style:
                TextStyle(fontSize: 28, fontWeight: FontWeight.bold,fontFamily: 'UthmanTNB'),
          ),
          Row(
            children: [
             
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: const Color(0xFF006C8D),
                child: IconButton(
                  icon:
                       Icon(rightIcon, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
