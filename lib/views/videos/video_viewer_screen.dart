import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/models/comment_model.dart';
import 'package:task/providers/auth_provider.dart';
import 'package:task/providers/comment_provider.dart';
import 'package:task/providers/reply_provider.dart';
import 'package:task/util/share_plus.dart';
import 'package:task/util/shimmer_effect.dart';
import 'package:task/util/video_player_widget.dart';
import 'package:task/views/videos/get_videos_by_id_page.dart';
import 'package:task/widgets/comment_widget.dart';

import '../../models/get_video_by_id.dart';
import '../../models/update_video.dart';
import '../../models/update_view_count.dart';
import '../../models/video_model.dart';

class VideoViewer extends ConsumerStatefulWidget {
  final String id;
  const VideoViewer({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VideoViewerState();
}

TextEditingController _replyTextController = TextEditingController();

class _VideoViewerState extends ConsumerState<VideoViewer> {
  bool isLiked = false;
  bool isDisliked = false;

  int likeCount = 0;
  int dislikeCount = 0;

  void likeVideo(Video video, String userId) {
    updateVideo(video, userId: userId, like: true);
    setState(() {
      if (isLiked) {
        likeCount--;

        isLiked = false;
      } else {
        likeCount++;

        if (isDisliked) {
          dislikeCount--;

          isDisliked = false;
        }
        isLiked = true;
      }
    });
  }

  void dislikeVideo(Video video, String userId) {
    updateVideo(video, userId: userId, dislike: true);
    setState(() {
      if (isDisliked) {
        dislikeCount--;

        isDisliked = false;
      } else {
        dislikeCount++;

        if (isLiked) {
          likeCount--;

          isLiked = false;
        }
        isDisliked = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoAsyncValue = ref.watch(videoProvider(widget.id));
    final userService = ref.read(authProvider);
    final commentNotifier = ref.watch(commentsProvider.notifier);
    return Dismissible(
      key: const Key('myScreen'),
      direction: DismissDirection.down,
      background: const ShimmerEffect(),
      onDismissed: (direction) {
        Navigator.of(context).pop();
      },
      child: Scaffold(
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
                if (video.likes!.contains(userService.currentUser.uid)) {
                  isLiked = true;
                  likeCount = video.likes!.length;
                  setState(() {});
                }

                if (video.dislikes!.contains(userService.currentUser.uid)) {
                  isDisliked = true;
                  dislikeCount = video.dislikes!.length;
                  setState(() {});
                }

                Future.delayed(
                    const Duration(seconds: 5),
                    () async =>
                        await updateVideoViewCount(video.id, video.views + 1));
print("############");
print(video.comments);
                commentNotifier.setComments(video.comments);

                List<Comment> comments = commentNotifier.getComments();

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SafeArea(
                        child: SizedBox(
                            width: double.infinity,
                            height: 250,
                            child: VideoPlayerWidget(
                              videoUrl: video.videoUrl,
                            )),
                      ),
                      Card(
                        child: ExpansionTile(
                          shape: const Border(),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${video.views} views - ${DateTime.now().difference(video.date).inDays} days ago',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          title: Text(
                            video.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          children: [
                            ListTile(
                              title: Text(
                                '${video.category}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  video.description ??
                                      "No description provided",
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
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
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          GetVideosByUserIdPage(
                                              userName: video.userName ?? "",
                                              userId: video.uploaderProfileId),
                                    )),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(video
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
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      likeVideo(
                                          video, userService.currentUser.uid);
                                    },
                                    icon: Icon(
                                      isLiked
                                          ? Icons.thumb_up_alt
                                          : Icons.thumb_up_alt_outlined,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  Text(
                                    likeCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      dislikeVideo(
                                          video, userService.currentUser.uid);
                                    },
                                    icon: Icon(
                                      isDisliked
                                          ? Icons.thumb_down_alt_rounded
                                          : Icons.thumb_down_alt_outlined,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  Text(
                                    dislikeCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      shareVideo(video.title, video.videoUrl);
                                    },
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
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        child: Text(
                          "Comments",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      CommentsListView(video: video),
                    ],
                  ),
                );
              }
            }),
      )),
    );
  }
}

class CommentsListView extends ConsumerStatefulWidget {
  Video video;
  CommentsListView({super.key, required this.video});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommentsListViewState();
}

class _CommentsListViewState extends ConsumerState<CommentsListView> {
  TextEditingController _replyTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch<CommentsNotifier>(commentsProvider);

    return Column(
      children: [
        // Comment text field and send button
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _replyTextController,
                    decoration: const InputDecoration(
                      hintText: 'Add a public comment',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_replyTextController.text.isNotEmpty) {
                      comments.addComment(
                        widget.video.id,
                        _replyTextController.text,
                      );
                      _replyTextController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ),

        // List of comments and replies
        ListView.builder(
          shrinkWrap: true,
          itemCount: comments.getComments().length,
          itemBuilder: (context, index) {
            final comment = comments.getComments()[index];
            final replyTextController = ref.read(replyTextControllerProvider);

            return Card(
              child: ExpansionTile(
                shape: const Border(),
                title: Text(comment.text),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Reply text field and send button
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: replyTextController,
                            decoration: const InputDecoration(
                              hintText: 'Type your reply...',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            if (replyTextController.text.isNotEmpty) {
                              comments.replyToComment(
                                widget.video.id,
                                comment.id,
                                replyTextController.text,
                              );
                              replyTextController.clear();
                            }
                          },
                        ),
                      ],
                    ),
                    // Comment date
                    // Text(comment.date.toString()),
                  ],
                ),
                trailing: null,
                children: comment.replies
                    .map(
                      (reply) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(reply.text),
                          subtitle: Text(reply.date.toString()),
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
