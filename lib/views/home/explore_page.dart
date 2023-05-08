import 'package:flutter/material.dart';
import 'package:task/util/search_bar.dart';
import 'package:task/views/videos/videoCard.dart';

import '../../models/video_model.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final _scrollController = ScrollController();
  late Stream<List<Video>> _videosStream;
  List<Video> _videos = [];

  @override
  void initState() {
    super.initState();
    _videosStream = getVideos();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more videos here
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Video>>(
      stream: _videosStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No videos found.'));
        }

        _videos = snapshot.data!;

        return Column(
          children: [
          SearchBar(),
          Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _videos.length,
                itemBuilder: (context, index) {
                  final video = _videos[index];
                  return VideoCard(video: video);
                },
              ),
            ),
          ],
        );
      },
    );
  }

}