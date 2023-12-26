import 'package:vit_buzz_bytes/utils/comment.dart';

class Buzz {
  final String id;
  final String text;
  final String? image;
  final String category;
  final List<dynamic> likes;
  final List<dynamic> dislikes;
  final bool? anonymous;
  final String createdBy;
  final List<dynamic> comments;
  final String? createdAt;
  final int? v;

  Buzz({
    required this.id,
    required this.text,
    required this.image,
    required this.category,
    required this.likes,
    required this.dislikes,
    required this.anonymous,
    required this.createdBy,
    required this.comments,
    required this.createdAt,
    required this.v,
  });

  factory Buzz.fromJson(Map<String, dynamic> json) {
    return Buzz(
      id: json['_id'],
      text: json['text'],
      image: json['image'],
      category: json['category'],
      likes: json['likes'],
      dislikes: json['dislikes'],
      anonymous: json['anonymous'],
      createdBy: json['createdBy'],
      comments: (json['comments'] as List)
          .map((commentJson) => BuzzComment.fromJson(commentJson))
          .toList(),
      createdAt: json['createdAt'],
      v: json['__v'],
    );
  }
}
