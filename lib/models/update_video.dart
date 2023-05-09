import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task/models/video_model.dart';
import 'package:task/util/show_snack_bar.dart';

Future<void> updateVideo(Video video,
    {String? userId, bool? like, bool? dislike}) async {
  try {
    final videoRef =
        FirebaseFirestore.instance.collection('videos').doc(video.id);

    List<String>? likeIds = video.likes;
    List<String>? dislikeIds = video.dislikes;

    if (like != null && like) {
      if (likeIds != null) {
        if (userId != null && !likeIds.contains(userId)) {
          likeIds.add(userId);
        }
      } else {
        likeIds = [userId!];
      }
      if (dislikeIds != null && userId != null) {
        dislikeIds.remove(userId);
      }
    }

    if (dislike != null && dislike) {
      if (dislikeIds != null) {
        if (userId != null && !dislikeIds.contains(userId)) {
          dislikeIds.add(userId);
        }
      } else {
        dislikeIds = [userId!];
      }
      if (likeIds != null && userId != null) {
        likeIds.remove(userId);
      }
    }

    await videoRef.update({
      // 'title': video.title,

      'likes': likeIds,

      'dislikes': dislikeIds,
      // 'views': video.views,
      // 'date': video.date,
      // 'category': video.category,
      // 'comments': video.comments.map((comment) => comment.toMap()).toList(),
      // 'uploaderProfileId': video.uploaderProfileId,
      // 'thumbnailUrl': video.thumbnailUrl,
      // 'videoUrl': video.videoUrl,
      // 'location': video.location,
      // 'userPhotoUrl': video.userPhotoUrl,
      // 'userName': video.userName,
      // 'description': video.description,
    });
    showPopupMessage("Updated");
  } catch (e) {
    showPopupMessage("Failed to update");
  }
}
