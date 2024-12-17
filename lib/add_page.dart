import 'dart:io';

import 'package:flutter/material.dart';
import 'package:game_hub/model/Writing.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_hub/providers/writing_provider.dart';

class AddPage extends ConsumerStatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends ConsumerState<AddPage> {
  File? _selectedImage;
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  final _detailController = TextEditingController();
  final _linkController = TextEditingController();

  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveArticle() async {
    if (_selectedImage == null || _titleController.text.isEmpty || _summaryController.text.isEmpty || _detailController.text.isEmpty || _linkController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 채워주세요!')),
      );
      return;
    }

    final writing = Writing(
      title: _titleController.text,
      summary: _summaryController.text,
      detail: _detailController.text,
      image: _selectedImage!.path,
      link: _linkController.text,
    );

    // Riverpod Provider를 사용하여 데이터베이스에 저장
    ref.read(writingProvider.notifier).addWriting(writing);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _detailController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child: _selectedImage == null ? Center(child: Text('이미지 추가')) : Image.file(_selectedImage!, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: '제목 입력창'),
            ),
            TextField(
              controller: _summaryController,
              decoration: InputDecoration(labelText: '요약 입력창'),
            ),
            TextField(
              controller: _detailController,
              decoration: InputDecoration(labelText: '내용 입력창'),
            ),
            TextField(
              controller: _linkController,
              decoration: InputDecoration(labelText: '링크 입력창'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveArticle,
              child: Text('게시하기'),
            ),
          ],
        ),
      ),
    );
  }
}
