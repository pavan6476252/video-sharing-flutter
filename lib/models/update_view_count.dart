import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateVideoViewCount(String videoId, int views) async {
  try{
  final videoRef = FirebaseFirestore.instance.collection('videos').doc(videoId);

  await videoRef.update({
    'views': views,
  });
  }catch(e){
    print("Failed to update View count");
  }
}
