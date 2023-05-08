


import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String id;
  String text;
  DateTime date;
  List<Comment> replies;

  Comment({
    required this.id,
    required this.text,
    required this.date,
    this.replies = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'date': date,
      'replies': replies.map((reply) => reply.toMap()).toList(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    final repliesData = map['replies'] ?? [];

    final replies = repliesData
        .map<Comment>((replyData) => Comment.fromMap(replyData))
        .toList();

    return Comment(
      id: map['id'],
      text: map['text'],
      date: map['date'].toDate(),
      replies: replies,
    );
  }
}


Future<void> addComment(String videoId, Comment comment) async {
  final videoRef = FirebaseFirestore.instance.collection('videos').doc(videoId);

  final videoSnapshot = await videoRef.get();

  if (!videoSnapshot.exists) {
    return;
  }

  final videoData = videoSnapshot.data();
  final commentsData = videoData!['comments'] ?? [];

  final comments = commentsData
      .map<Comment>((commentData) => Comment.fromMap(commentData))
      .toList();

  comments.add(comment);

  await videoRef.update({
    'comments': comments.map((comment) => comment.toMap()).toList(),
  });
}

Future<void> replyToComment(
    String videoId, String commentId, Comment reply) async {
  final videoRef = FirebaseFirestore.instance.collection('videos').doc(videoId);

  final videoSnapshot = await videoRef.get();

  if (!videoSnapshot.exists) {
    return;
  }

  final videoData = videoSnapshot.data();
  final commentsData = videoData!['comments'] ?? [];

  final comments = commentsData
      .map<Comment>((commentData) => Comment.fromMap(commentData))
      .toList();

  final commentIndex =
      comments.indexWhere((comment) => comment.id == commentId);

  if (commentIndex < 0) {
    return;
  }

  final comment = comments[commentIndex];
  final replies = comment.replies;

  replies.add(reply);

  await videoRef.update({
    'comments': comments.map((comment) => comment.toMap()).toList(),
  });
}
