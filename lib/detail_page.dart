import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:game_hub/data/database_helper.dart';
import 'package:game_hub/model/Comment.dart';
import 'package:game_hub/model/Writing.dart';

class DetailPage extends StatefulWidget {
  final Writing writing;

  DetailPage({required this.writing});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _commentController = TextEditingController();
  late Future<List<Comment>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _loadComments();
    _showTableNames(); // 테이블 목록을 로드
  }

  // 테이블 목록 출력 함수
  void _showTableNames() async {
    final tableNames = await DatabaseHelper.instance.getTableNames();
    print('Tables in the database:');
    tableNames.forEach((tableName) {
      print(tableName);
    });
  }

  // 댓글 불러오기
  void _loadComments() {
    _commentsFuture = DatabaseHelper.instance.getCommentsForWriting(widget.writing.id!);
  }

  // 댓글 추가 함수
  Future<void> _addComment() async {
    final commentContent = _commentController.text;
    if (commentContent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글을 입력해주세요!')),
      );
      return;
    }

    final comment = Comment(
      writingId: widget.writing.id!,
      content: commentContent,
    );

    // Comment 객체를 삽입
    await DatabaseHelper.instance.insertComment(comment);
    _commentController.clear();

    setState(() {
      _loadComments();
    });
  }

  // 하이퍼링크 열기
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('링크를 열 수 없습니다: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.writing.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 출력
            widget.writing.image.isNotEmpty
                ? Image.file(
                    File(widget.writing.image),
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
              widget.writing.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // 요약 출력
            Text(
              widget.writing.summary,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 10),
            // 링크 출력 (하이퍼링크)
            GestureDetector(
              onTap: () => _launchURL(widget.writing.link),
              child: Text(
                widget.writing.link,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 20),
            // 내용 출력
            Text(
              widget.writing.detail,
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
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addComment,
              child: Text('댓글 달기'),
            ),
            SizedBox(height: 20),
            // 댓글 리스트
            FutureBuilder<List<Comment>>(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
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
