import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/video_model.dart';

Future<List<Video>> getVideosByUser(String userId) async {
  final videosRef = FirebaseFirestore.instance.collection('videos');

  final query = videosRef.where('uploaderProfileId', isEqualTo: userId);

  final snapshot = await query.get();
  final videosData = snapshot.docs.map((doc) => doc.data()).toList();

  return videosData.map<Video>((videoData) => Video.fromMap(videoData)).toList();
}

final videosByUserProvider = FutureProvider.family<List<Video>, String>((ref, userId) async {
  return getVideosByUser(userId);
});
