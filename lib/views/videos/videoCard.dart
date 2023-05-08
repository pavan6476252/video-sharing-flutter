import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:task/util/cached_image.dart';
import 'package:task/views/videos/video_viewer_screen.dart';

import '../../models/video_model.dart';

class VideoCard extends StatelessWidget {
  final Video video;

  VideoCard({Key? key, required this.video}) : super(key: key);

  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoViewer(video: video),
              ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  video.thumbnailUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                ListTile(
                  trailing: Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          // TODO: Implement share button
                        },
                      ),
                    ],
                  ),
                  leading: const CircleAvatar(
                    radius: 16,
                    backgroundImage: CachedNetworkImageProvider(
                      'https://via.placeholder.com/150',
                    ),
                  ),
                  title: Text(
                    video.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Row(
                    children: [
                      const Text(
                        // TODO: Replace with uploader name
                        'Uploader Name',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.check_circle,
                          color: Colors.blue, size: 16),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.remove_red_eye_rounded,
                        size: 15,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${video.views} views',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        ' ${now.difference(video.date).inDays} days ago',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        video.location,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
