class Writing {
  final int? id;
  final String title;
  final String detail;
  final String summary;
  final String image;
  final String link;

  Writing({this.id, required this.title, required this.detail, required this.summary, required this.image, required this.link});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'detail': detail,
      'summary': summary,
      'image': image,
      'link': link,
    };
  }

  static Writing fromMap(Map<String, dynamic> map) {
    return Writing(
      id: map['id'],
      title: map['title'],
      detail: map['detail'],
      summary: map['summary'],
      image: map['image'],
      link: map['link'],
    );
  }
}
