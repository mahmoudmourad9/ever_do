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
  bool _isPicking = false; // لمنع الضغط المتكرر

  @override
  void initState() {
    super.initState();
    _pickedImage = widget.initialImage;
  }

  Future<void> _pickImage() async {
    if (_isPicking) return; // منع النقر المزدوج
    setState(() => _isPicking = true);

    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 75);

    if (image != null && mounted) {
      setState(() => _pickedImage = File(image.path));
      widget.onImagePicked(_pickedImage);
    }

    setState(() => _isPicking = false);
  }

  @override
  Widget build(BuildContext context) {
    final Color inputFillColor =
        widget.isDarkMode ? Colors.grey.shade800 : Colors.black12;

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: inputFillColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: _pickedImage == null
            ? Center(
                child: Text(
                  'أضف صورة...',
                  style: TextStyle(
                    color:
                        widget.isDarkMode ? Colors.white54 : Colors.black45,
                    fontSize: 16,
                  ),
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _pickedImage!,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
