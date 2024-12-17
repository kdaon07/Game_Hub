class Comment {
  final int? id;
  final int writingId; // 댓글이 속한 게시글의 ID
  final String content; // 댓글 내용

  Comment({this.id, required this.writingId, required this.content});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'writingId': writingId,
      'content': content,
    };
  }

  static Comment fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      writingId: map['writingId'],
      content: map['content'],
    );
  }
}
