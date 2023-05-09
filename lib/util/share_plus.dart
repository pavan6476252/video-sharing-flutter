import 'package:share_plus/share_plus.dart';

void shareVideo(String videoTitle, String videoUrl) {
  final String text = 'Check out this video: $videoTitle $videoUrl';
  Share.share(text);
}
