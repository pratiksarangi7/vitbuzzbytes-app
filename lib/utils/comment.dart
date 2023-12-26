class BuzzComment {
  final String text;
  final String userID;
  final DateTime createdAt;
  final String id;

  BuzzComment(
      {required this.text,
      required this.userID,
      required this.createdAt,
      required this.id});

  factory BuzzComment.fromJson(Map<String, dynamic> json) {
    return BuzzComment(
      text: json['text'],
      userID: json['userID'],
      createdAt: DateTime.parse(json['createdAt']),
      id: json['_id'],
    );
  }
}
