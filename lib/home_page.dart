import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 관련 import
import 'package:game_hub/providers/writing_provider.dart'; // writingProvider import 추가
import 'detail_page.dart';
import 'add_page.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final writings = ref.watch(writingProvider); // writingProvider 구독

    return Scaffold(
      appBar: AppBar(
        title: Text('헤더'),
      ),
      body: writings.isEmpty
          ? Center(child: Text('게시물이 없습니다.'))
          : ListView.builder(
              itemCount: writings.length,
              itemBuilder: (context, index) {
                final writing = writings[index];
                return ListTile(
                  leading: writing.image.isNotEmpty
                      ? Image.file(
                          File(writing.image),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey[300],
                          child: Icon(Icons.image, color: Colors.grey[600]),
                        ),
                  title: Text(writing.title),
                  subtitle: Text(writing.summary),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(writing: writing),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
