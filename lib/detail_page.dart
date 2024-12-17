import 'dart:io';
import 'package:flutter/material.dart';
import 'package:game_hub/data/database_helper.dart';
import 'package:game_hub/model/Comment.dart';
import 'model/Writing.dart';

class DetailPage extends StatelessWidget {
  final Writing writing;

  DetailPage({required this.writing});

  final _commentController = TextEditingController();

  // 댓글 추가 함수
  Future<void> _addComment(BuildContext context) async {
    final commentContent = _commentController.text;
    if (commentContent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글을 입력해주세요!')),
      );
      return;
    }

    final comment = Comment(writingId: writing.id!, content: commentContent);
    await DatabaseHelper.instance.insertComment(comment);

    _commentController.clear(); // 댓글 입력 필드 비우기
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(writing: writing)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(writing.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 출력
            writing.image.isNotEmpty
                ? Image.file(
                    File(writing.image),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
                  ),
            SizedBox(height: 20),
            // 제목 출력
            Text(
              writing.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // 요약 출력
            Text(
              writing.summary,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 20),
            // 내용 출력
            Text(
              writing.detail,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // 댓글 입력 필드
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: '댓글을 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () => _addComment(context),
              child: Text('댓글 달기'),
            ),
            SizedBox(height: 20),
            // 댓글 리스트
            FutureBuilder<List<Comment>>(
              future: DatabaseHelper.instance.getCommentsForWriting(writing.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('댓글이 없습니다.');
                }

                final comments = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return ListTile(
                      title: Text(comment.content),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
