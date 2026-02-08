import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerCard extends StatefulWidget {
  final File? initialImage;
  final ValueChanged<File?> onImagePicked;
  final bool isDarkMode;

  const ImagePickerCard({
    super.key,
    required this.onImagePicked,
    this.initialImage,
    this.isDarkMode = false,
  });

  @override
  State<ImagePickerCard> createState() => _ImagePickerCardState();
}

class _ImagePickerCardState extends State<ImagePickerCard> {
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;
  bool _isPicking = false;

  @override
  void initState() {
    super.initState();
    _pickedImage = widget.initialImage;
  }

  Future<void> _pickImage() async {
    if (_isPicking) return;
    setState(() => _isPicking = true);

    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 75);

    if (image != null && mounted) {
      setState(() => _pickedImage = File(image.path));
      widget.onImagePicked(_pickedImage);
    }

    setState(() => _isPicking = false);
  }

  void _removeImage() {
    setState(() => _pickedImage = null);
    widget.onImagePicked(null);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = widget.isDarkMode;

    if (_pickedImage != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(
              _pickedImage!,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: _removeImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.blue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white24 : primaryColor.withOpacity(0.3),
            width: 2,
            style: BorderStyle
                .none, // We'll simulate dash with something else if needed, but solid is cleaner.
          ), // Let's try simple styling first
        ),
        // Dashed border simulation with CustomPaint is heavyweight,
        // let's use a nice subtle border for "Ice" feel.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_rounded,
              size: 40,
              color: isDark ? Colors.white54 : primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 10),
            Text(
              'أضف صورة للذكرى',
              style: TextStyle(
                color: isDark ? Colors.white54 : primaryColor.withOpacity(0.6),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
