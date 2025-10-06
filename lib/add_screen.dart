import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddScreen extends StatefulWidget {
  final Map<String, dynamic>? initialEntry;
  const AddScreen({super.key, this.initialEntry});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;
  int _selectedEmoji = 2;
  double _sliderValue = 0.5;
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.initialEntry != null) {
      final e = widget.initialEntry!;
      _controller.text = e['text'] ?? '';
      _selectedEmoji = e['emojiIndex'] ?? 2;
      _sliderValue = (e['sliderValue'] ?? 0.5).toDouble();
      _date = DateTime.fromMillisecondsSinceEpoch(e['date'] ?? DateTime.now().millisecondsSinceEpoch);
      if (e['imagePath'] != null) _pickedImage = File(e['imagePath']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF004A63),
        elevation: 0,
        title: const Text('إضافة', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_date.day} / ${_date.month} / ${_date.year}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                IconButton(icon: const Icon(Icons.calendar_month, color: Color(0xFF004A63)), onPressed: _pickDate),
              ],
            ),
            const SizedBox(height: 20),
            const Text('شعورك اليوم', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(5, (i) {
                        return GestureDetector(
                          onTap: () => setState(() => _selectedEmoji = i),
                          child: Opacity(
                            opacity: _selectedEmoji == i ? 1.0 : 0.5,
                            child: Text(_emojiFromIndex(i), style: const TextStyle(fontSize: 30)),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    Slider(value: _sliderValue, onChanged: (v) => setState(() => _sliderValue = v)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('إضافة صورة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 130,
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                child: _pickedImage == null
                    ? const Center(child: Text('أضف صورة...', style: TextStyle(color: Colors.black45)))
                    : ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(_pickedImage!, width: double.infinity, height: 130, fit: BoxFit.cover)),
              ),
            ),
            const SizedBox(height: 25),
            const Text('اليومية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'ما الذي تريد إضافته اليوم',
                hintStyle: const TextStyle(color: Colors.black38),
                filled: true,
                fillColor: Colors.black12,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004A63),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _save,
                child: const Text('حفظ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  String _emojiFromIndex(int i) {
    const list = ['😡','☹️','🙂','😄','😍'];
    if (i < 0 || i >= list.length) return '🙂';
    return list[i];
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (image != null) setState(() => _pickedImage = File(image.path));
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (picked != null) setState(() => _date = picked);
  }

  void _save() {
    final Map<String, dynamic> result = {
      'date': _date.millisecondsSinceEpoch,
      'text': _controller.text.trim(),
      'emojiIndex': _selectedEmoji,
      'sliderValue': _sliderValue,
      'imagePath': _pickedImage?.path,
    };
    Navigator.pop(context, result);
  }
}
