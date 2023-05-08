import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

CachedNetworkImage showCachedNetworkImage(String url) {
  return CachedNetworkImage(
    imageUrl: url,
   
  );
}


class VideoThumbnail extends StatelessWidget {
  final String thumbnailUrl;

  const VideoThumbnail({Key? key, required this.thumbnailUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: CachedNetworkImage(
        imageUrl: thumbnailUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
      ),
    );
  }
}


class VideoThumbnailProvider extends StatelessWidget {
  final String thumbnailUrl;

  const VideoThumbnailProvider({Key? key, required this.thumbnailUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Image(
        image: CachedNetworkImageProvider(
          thumbnailUrl,
        ),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(child: Icon(Icons.error));
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
    );
  }
}
