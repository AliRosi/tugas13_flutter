class BookModel {
  final int? id;
  final String title;
  final String author;
  final String description;
  final bool isRead;
  BookModel({
    this.id,
    required this.title,
    required this.author,
    required this.description,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'isRead': isRead ? 1 : 0,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      description: map['description'] ?? '',
      isRead: map['isRead'] == 1,
    );
  }
}
