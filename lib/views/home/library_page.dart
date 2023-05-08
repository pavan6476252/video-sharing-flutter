import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/providers/delete_video_provider.dart';
import 'package:task/util/cached_image.dart';
import 'package:task/util/shimmer_effect.dart';
import 'package:task/views/profile/user_profile.dart';
import 'package:task/views/videos/video_viewer_screen.dart';

import '../../models/video_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/videos_by_user_provider.dart';

class LibraryPage extends ConsumerWidget {
  LibraryPage({super.key});

  @override
  final _formKey = GlobalKey<FormState>();

 Widget _buildProfileAvatar(BuildContext context, String? photoURL, String name, String phone, String uid) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CircleAvatar(
        radius: 60,
        backgroundImage: CachedNetworkImageProvider(
          photoURL ?? "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541",
          errorListener: () {},
        ),
      ),
      const SizedBox(height: 20),
      Text(
        name,
        style: Theme.of(context).textTheme.headline6,
      ),
      Text(
        phone,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      Text(
        'UID: $uid',
        style: Theme.of(context).textTheme.subtitle2,
      ),
      SizedBox(height: 8),

      SizedBox(
        
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserProfilePage()),
            );
          },
          icon: Icon(Icons.person),
          label: Text('My Profile'),
          style: ElevatedButton.styleFrom(
          
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    ],
  );
}


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch<AuthService>(authProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildProfileAvatar(
                context,
                authService.currentUser.photoURL,
                authService.currentUser.displayName,
                authService.currentUser.phoneNumber,
                authService.currentUser.uid),
            const SizedBox(height: 15),
            const Text("Uploaded Videos",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            const SizedBox(height: 10),
            Expanded(
              child: _uploadedVideosBuilder(
                  context, ref, authService.currentUser.uid),
            ),
          ],
        ),
      ),
    );
  }

  _uploadedVideosBuilder(BuildContext context, WidgetRef ref, String uid) {
    final videos = ref.watch(videosByUserProvider(uid));
    return videos.when(
        error: (error, stackTrace) => Center(
              child: Text("Error $error"),
            ),
        loading: () => const ShimmerEffect(),
        data: (data) => VideoList(videos: data));
  }
}

class VideoList extends StatefulWidget {
  final List<Video> videos;

  const VideoList({Key? key, required this.videos}) : super(key: key);

  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  @override
  ScrollController scrollController = ScrollController();
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        itemCount: widget.videos.length,
        itemBuilder: (BuildContext context, int index) {
          final video = widget.videos[index];
    
          return Card(
            child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoViewer(id: video.id),
                    )),
                child: Dismissible(
                  key: Key(video.id),
                  onDismissed: (direction) {
                    setState(() {
                      widget.videos.removeAt(index);
                    });
    
                    final snackBar = SnackBar(
                      content: Text('${video.title} deleted'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          setState(() {
                            widget.videos.insert(index, video);
                          });
                        },
                      ),
                    );
    
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar)
                        .closed
                        .then((reason) {
                      if (reason == SnackBarClosedReason.action) {
                        return;
                      }
                      deleteVideo(video.id);
                      setState(() {});
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    leading: VideoThumbnail(thumbnailUrl: video.thumbnailUrl),
                    title: Text(video.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${video.views} views • ${_getTimeSincePosted(video.date)}'),
                      ],
                    ),
                  ),
                )),
          );
        },
      ),
    );
  }

  String _getTimeSincePosted(DateTime posted) {
    final now = DateTime.now();
    final difference = now.difference(posted);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }
}
