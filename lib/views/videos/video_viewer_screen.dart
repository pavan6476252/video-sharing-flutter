import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/home_page.dart';
import 'package:task/models/comment_model.dart';
import 'package:task/util/shimmer_effect.dart';
import 'package:task/util/video_player_widget.dart';
import 'package:task/widgets/comment_widget.dart';

import '../../models/get_video_by_id.dart';
import '../../models/update_view_count.dart';
import '../../models/video_model.dart';

class VideoViewer extends ConsumerWidget {
  final String id;

  const VideoViewer({Key? key, required this.id}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoAsyncValue = ref.watch(videoProvider(id));

    return Dismissible(
  key: const Key('myScreen'),
  direction: DismissDirection.down,
  background: ShimmerEffect(),
  onDismissed: (direction) {
    Navigator.of(context).pop();
  },
  child:  Scaffold(
          body: SafeArea(
        child: videoAsyncValue.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) {
              // print(stackTrace);
              return Center(child: Text('Error loading video: $stackTrace'));
            },
            data: (video) {
              if (video == null) {
                return const Text('Video not found');
              } else {
                Future.delayed(
                    const Duration(seconds: 5),
                    () async =>
                        await updateVideoViewCount(video.id, video.views + 1));
                return Column(
                  children: [
                    SafeArea(
                      child: Container(
                          width: double.infinity,
                          height: 250,
                          child: VideoPlayerWidget(
                            videoUrl: video.videoUrl,
                          )),
                    ),
                    Card(
                      child: ExpansionTile(
                        shape: const Border(),
                        subtitle: Text(
                          '${video.views} views',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        title: Text(
                          video.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              video.description ?? "No description provided",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(video
                                          .userPhotoUrl ??
                                      "https://cdn.drawception.com/images/avatars/647493-B9E.png"),
                                  radius: 20,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  video.userName ?? "Unkown",
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
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: video.comments.length,
                        itemBuilder: (BuildContext context, int index) {
                          final comment = video.comments[index];
                          return CommentWidget(
                            comment: comment,
                            videoId: video.id,
                          );
                        },
                      ),
                    ),
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
                            onPressed: () {
                              addComment(
                                  video.id,
                                  Comment(
                                      id: video.uploaderProfileId,
                                      text: 'TestComment',
                                      date: DateTime.now()));
                            },
                            icon: const Icon(Icons.send),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            }),
      )),
    );
  }
}
