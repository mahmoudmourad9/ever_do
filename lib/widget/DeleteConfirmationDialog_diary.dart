import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Color cardColor;
  final Color textColor;
  final Color secondaryTextColor;

  const DeleteConfirmationDialog({
    super.key,
    required this.cardColor,
    required this.textColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: cardColor,
      title: Text('حذف اليومية', style: TextStyle(color: textColor)),
      content: Text(
        'هل تريد حذف هذه اليومية؟',
        style: TextStyle(color: secondaryTextColor),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('نعم'),
        ),
      ],
    );
  }
}
