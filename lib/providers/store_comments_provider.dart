// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../models/comment_model.dart';

// class CommentNotifier extends ChangeNotifier {
//   late Comment _comment;

//   CommentNotifier();

//   Comment get comment => _comment;

//   void addReply(Comment reply) {
//     _comment.replies.add(reply);
//     notifyListeners();
//   }

//   void updateComment(String text) {
//     _comment.text = text;
//     notifyListeners();
//   }

//   void deleteReply(Comment reply) {
//     _comment.replies.remove(reply);
//     notifyListeners();
//   }
// }

// final commentProvider  = ChangeNotifierProvider<Comment>((ref) {
//     return CommentNotifier();
//   });
