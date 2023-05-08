import 'package:flutter/material.dart';
import 'package:task/views/videos/videoCard.dart';

import '../../models/video_model.dart';

class VideoSearchScreen extends StatefulWidget {
  const VideoSearchScreen({Key? key}) : super(key: key);

  @override
  _VideoSearchScreenState createState() => _VideoSearchScreenState();
}

class _VideoSearchScreenState extends State<VideoSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  Future<List<Video>>? _futureVideos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search Videos...',
          ),
          onSubmitted: (value) async{
            if (value.isNotEmpty) {
              
              setState(() {
              });
            }
          },
        ),
      ),
    
       
      
    );
  }
}
