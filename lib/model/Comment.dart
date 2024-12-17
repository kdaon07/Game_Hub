class Comment {
  int? id; // id를 nullable로 설정
  final int writingId;
  final String content;

  Comment({
    this.id, // 생성 시 id를 생략할 수 있도록 변경
    required this.writingId,
    required this.content,
  });

  // Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id, // id가 없을 수 있기 때문에 nullable로 처리
      'writingId': writingId,
      'content': content,
    };
  }

  // Map에서 Comment 객체로 변환
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      writingId: map['writingId'],
      content: map['content'],
    );
  }
}
