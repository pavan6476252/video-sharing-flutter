import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/models/comment_model.dart';
import 'package:task/models/video_model.dart';

final videoProvider = FutureProvider.family<Video?, String>((ref, id) async {
  final videoRef = FirebaseFirestore.instance.collection('videos').doc(id);
  final videoSnapshot = await videoRef.get();

  if (!videoSnapshot.exists) {
    return null;
  }

  final data = videoSnapshot.data();
  final commentsData = data!['comments'] ?? [];

  final comments = commentsData
      .map<Comment>((commentData) => Comment.fromMap(commentData))
      .toList();

  return Video(
    id: id,
    title: data['title'],
    likes: data['likes'],
    dislikes: data['dislikes'],
    views: data['views'],
    date: DateTime.parse(data['date']),
    category: data['category'],
    comments: comments,
    uploaderProfileId: data['uploaderProfileId'],
    thumbnailUrl: data['thumbnailUrl'],
    videoUrl: data['videoUrl'],
    location: data['location'],
    userPhotoUrl: data['userPhotoUrl'],
    userName: data['userName'],
    description: data['description'],
  );
});
