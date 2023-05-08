import 'package:flutter/material.dart';
import 'package:task/util/video_player_widget.dart';

import '../../models/video_model.dart';

class VideoViewer extends StatelessWidget {
  final Video video;

  const VideoViewer({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Column(
        children: [
          SafeArea(
            child: Container(
                width: double.infinity,
                height: 250,
                child: VideoPlayerWidget(
                  videoUrl: video.videoUrl,
                )),
          ),
          ExpansionTile(
            subtitle: Text(
              '${video.views} views',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            title: Text(
              video.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  " video.description,",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.thumb_up_alt_outlined,
                      color: Colors.blueGrey,
                    ),
                  ),
                  Text(
                    '${video.likes}',
                    style: const TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.thumb_down_alt_outlined,
                      color: Colors.blueGrey,
                    ),
                  ),
                  Text(
                    '${video.dislikes}',
                    style: const TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share_outlined,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const Text(
                    'Share',
                    style: TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: video.comments.length,
              itemBuilder: (BuildContext context, int index) {
                final comment = video.comments[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(comment.id),
                  ),
                  title: Text(comment.text),
                  subtitle: Text(comment.date.toLocal().toString()),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Add a public comment',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
