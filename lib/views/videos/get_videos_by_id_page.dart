import 'package:firebase_admin/firebase_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/util/shimmer_effect.dart';
import 'package:task/views/videos/videoCard.dart';

import '../../models/get_videos_by_user.dart';

class GetVideosByUserIdPage extends ConsumerStatefulWidget {
  String userId;
String userName ;
  GetVideosByUserIdPage({super.key, required this.userId,required this.userName});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GetVideosByUserIdPageState();
}

class _GetVideosByUserIdPageState extends ConsumerState<GetVideosByUserIdPage> {
  @override
  Widget build(BuildContext context) {
    final videosAsyncValue = ref.watch(videosByUserProvider(widget.userId));
   

    return Scaffold(
      appBar: AppBar(title: Text(widget.userName)),
      body: videosAsyncValue.when(
        loading: () => ShimmerEffect(),
        error: (error, stackTrace) =>
            Center(child: Text('Failed to load videos: $error')),
        data: (videos) => ListView.builder(
          itemCount: videos.length,
          itemBuilder: (context, index) {
            
            return VideoCard(video: videos[index]);},
        ),
      ),
    );
  }
}
