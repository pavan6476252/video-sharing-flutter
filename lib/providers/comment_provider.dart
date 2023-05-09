import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:task/models/comment_model.dart';
import 'package:task/util/show_snack_bar.dart';

final commentsProvider = ChangeNotifierProvider<CommentsNotifier>((ref) {
  return CommentsNotifier();
});

class CommentsNotifier extends ChangeNotifier {
  List<Comment> _comments = [];

  List<Comment> get comments => _comments;

  Future<Comment> addComment(String videoId, String commentText) async {
    final newComment = Comment(
      id: UniqueKey().toString(),
      text: commentText,
      date: DateTime.now(),
    );
    try {
      addCommentToDB(videoId, newComment);
      showPopupMessage("comment added");
    } catch (e) {
      showPopupMessage("Adding coumment failed");
    }
    _comments = [..._comments, newComment];
    notifyListeners();
    return newComment;
  }

  Future<void> replyToComment(
      String videoId, String commentId, String replyText) async {
    final newReply = await addComment(videoId, replyText);
    try {
      addReplyToCommentDB(videoId, commentId, newReply);
      showPopupMessage("reply added");
    } catch (e) {
      showPopupMessage("Adding coumment failed");
    }
    _comments = List<Comment>.from(_comments.map((comment) {
      if (comment.id == commentId) {
        return comment.copyWith(replies: [...comment.replies, newReply]);
      }
      return comment;
    }));
    notifyListeners();
  }

  List<Comment> getComments() {
    return _comments;
  }

  Future<void> setComments(List<Comment> comments) async {
    _comments = comments;
    notifyListeners();
  }
}
