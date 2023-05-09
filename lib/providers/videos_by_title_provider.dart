import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/providers/search_bar_provider.dart';

import '../models/video_model.dart';

final videoByTitleProvider = FutureProvider.autoDispose<List<Video>>((ref) async {
  final videosRef = FirebaseFirestore.instance.collection('videos');

  // Get the search term from a state provider
  // final searchTerm = ref.read(searchTermControllerProvider).text;

  final query = videosRef.where('title', isGreaterThanOrEqualTo: 'djhd');

  final snapshot = await query.get();

  final videosData = snapshot.docs.map((doc) => doc.data()).toList();

  return videosData
      .map<Video>((videoData) => Video.fromMap(videoData))
      .toList();
});


 