import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'comment_model.dart';

// class Video {
//     String id;
//   String title;
//   int likes;
//   int dislikes;
//   int views;
//   DateTime date;
//   String category;
//   List<Comment> comments;
//   String uploaderProfileId;
//   String thumbnailUrl;
//   String videoUrl;
//   String location;

//   Video({
//     required this.id,
//     required this.title,
//     this.likes = 0,
//     this.dislikes = 0,
//     this.views = 0,
//     required this.date,
//     required this.category,
//     this.comments = const [],
//     required this.uploaderProfileId,
//     required this.thumbnailUrl,
//      required this.videoUrl,
//      required this.location,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'likes': likes,
//       'dislikes': dislikes,
//       'views': views,
//       'date': date.toIso8601String(),
//       'category': category,
//       'comments': comments.map((comment) => comment.toMap()).toList(),
//       'uploaderProfileId': uploaderProfileId,
//       'thumbnailUrl': thumbnailUrl,
//       'videoUrl' :videoUrl,
//       'location':location,
//     };
//   }

//   factory Video.fromMap(Map<String, dynamic> map) {
//     return Video(
//       id: map['id'],
//       title: map['title'],
//       likes: map['likes'],
//       dislikes: map['dislikes'],
//       views: map['views'],
//       date: DateTime.parse(map['date']),
//       category: map['category'],
//       comments: List<Comment>.from(map['comments'].map((commentMap) => Comment.fromMap(commentMap))),
//       uploaderProfileId: map['uploaderProfileId'], thumbnailUrl: map['thumbnailUrl'],
//       videoUrl: map['videoUrl'],
//       location: map['location'],
//     );
//   }
// }

// class Video {
//   String id;
//   String title;
//   int likes;
//   int dislikes;
//   int views;
//   DateTime date;
//   String category;
//   List<Comment> comments;
//   String uploaderProfileId;
//   String thumbnailUrl;
//   String videoUrl;
//   String location;
//   String? userPhotoUrl;
//   String? userName;
//   String? description;

//   Video({
//     required this.id,
//     required this.title,
//     this.likes = 0,
//     this.dislikes = 0,
//     this.views = 0,
//     required this.date,
//     required this.category,
//     this.comments = const [],
//     required this.uploaderProfileId,
//     required this.thumbnailUrl,
//     required this.videoUrl,
//     required this.location,
//     this.userPhotoUrl,
//     this.userName,
//     this.description,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'likes': likes,
//       'dislikes': dislikes,
//       'views': views,
//       'date': date.toIso8601String(),
//       'category': category,
//       'comments': comments.map((comment) => comment.toMap()).toList(),
//       'uploaderProfileId': uploaderProfileId,
//       'thumbnailUrl': thumbnailUrl,
//       'videoUrl': videoUrl,
//       'location': location,
//       'userPhotoUrl': userPhotoUrl,
//       'userName': userName,
//       'description': description,
//     };
//   }

//   factory Video.fromMap(Map<String, dynamic> map) {
//     return Video(
//       id: map['id'],
//       title: map['title'],
//       likes: map['likes'],
//       dislikes: map['dislikes'],
//       views: map['views'],
//       date: DateTime.parse(map['date']),
//       category: map['category'],
//       comments: List<Comment>.from(map['comments'].map((commentMap) => Comment.fromMap(commentMap))),
//       uploaderProfileId: map['uploaderProfileId'],
//       thumbnailUrl: map['thumbnailUrl'],
//       videoUrl: map['videoUrl'],
//       location: map['location'],
//       userPhotoUrl: map['userPhotoUrl'],
//       userName: map['userName'],
//       description: map['description'],
//     );
//   }
// }

class Video {
  String id;
  String title;
  List<String>? likes;
  List<String>? dislikes;
  int views;
  DateTime date;
  String category;
  List<Comment> comments;
  String uploaderProfileId;
  String thumbnailUrl;
  String videoUrl;
  String location;
  String? userPhotoUrl;
  String? userName;
  String? description;

  Video({
    required this.id,
    required this.title,
    this.likes = const [],
    this.dislikes = const [],
    this.views = 0,
    required this.date,
    required this.category,
    this.comments = const [],
    required this.uploaderProfileId,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.location,
    this.userPhotoUrl,
    this.userName,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'likes': likes,
      'dislikes': dislikes,
      'views': views,
      'date': date.toIso8601String(),
      'category': category,
      'comments': comments.map((comment) => comment.toMap()).toList(),
      'uploaderProfileId': uploaderProfileId,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
      'location': location,
      'userPhotoUrl': userPhotoUrl,
      'userName': userName,
      'description': description,
    };
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map['id'],
      title: map['title'],
      likes: List<String>.from(map['likes'] ?? []),
      dislikes: List<String>.from(map['dislikes'] ?? []),
      views: map['views'],
      date: DateTime.parse(map['date']),
      category: map['category'],
      comments: List<Comment>.from(
          map['comments'].map((commentMap) => Comment.fromMap(commentMap))),
      uploaderProfileId: map['uploaderProfileId'],
      thumbnailUrl: map['thumbnailUrl'],
      videoUrl: map['videoUrl'],
      location: map['location'],
      userPhotoUrl: map['userPhotoUrl'],
      userName: map['userName'],
      description: map['description'],
    );
  }
}

// Future<Video?> getVideo(String id) async {
//   final videoRef = FirebaseFirestore.instance.collection('videos').doc(id);
//   final videoSnapshot = await videoRef.get();

//   if (!videoSnapshot.exists) {
//     return null;
//   }

//   final data = videoSnapshot.data();
//   final commentsData = data!['comments'] ?? [];

//   final comments = commentsData
//       .map<Comment>((commentData) => Comment.fromMap(commentData))
//       .toList();

//   return Video(
//     id: id,
//     title: data['title'],
//     likes: data['likes'],
//     dislikes: data['dislikes'],
//     views: data['views'],
//     date: data['date'].toDate(),
//     category: data['category'],
//     comments: comments,
//     uploaderProfileId: data['uploaderProfileId'], thumbnailUrl: data['thumbnailUrl'],
//     videoUrl : data['videoUrl'],
//     location:data['location']
//   );
// }

// class VideoService {
// Future<Video?> getVideo(String id) async {
//   final videoRef = FirebaseFirestore.instance.collection('videos').doc(id);
//   final videoSnapshot = await videoRef.get();

//   if (!videoSnapshot.exists) {
//     return null;
//   }

//   final data = videoSnapshot.data();
//   final commentsData = data!['comments'] ?? [];

//   final comments = commentsData
//       .map<Comment>((commentData) => Comment.fromMap(commentData))
//       .toList();

//   return Video(
//     id: id,
//     title: data['title'],
//     likes: data['likes'],
//     dislikes: data['dislikes'],
//     views: data['views'],
//     date: data['date'].toDate(),
//     category: data['category'],
//     comments: comments,
//     uploaderProfileId: data['uploaderProfileId'],
//     thumbnailUrl: data['thumbnailUrl'],
//     videoUrl: data['videoUrl'],
//     location: data['location'],
//     userPhotoUrl: data['userPhotoUrl'],
//     userName: data['userName'],
//     description: data['description'],
//   );
// }
// }

// Future<void> updateVideo(Video video) async {
//   final videoRef =
//       FirebaseFirestore.instance.collection('videos').doc(video.id);

//   await videoRef.update({
//     'title': video.title,
//     'likes': video.likes,
//     'dislikes': video.dislikes,
//     'views': video.views,
//     'date': video.date,
//     'category': video.category,
//     'comments': video.comments.map((comment) => comment.toMap()).toList(),
//     'uploaderProfileId': video.uploaderProfileId,
//     'location' :video.location,
//   });
// }

// Stream<List<Video>> getVideos() {

//   final videosRef = FirebaseFirestore.instance.collection('videos');

//   return videosRef.snapshots().map((snapshot) {
//     final videosData = snapshot.docs.map((doc) => doc.data()).toList();

//     return videosData.map<Video>((videoData) => Video.fromMap(videoData)).toList();
//   });

// }

Future<List<Video>> getVideos() async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('videos').get();
   
    List<Video> videos =
        snapshot.docs.map((doc) => Video.fromMap(doc.data())).toList();

    return videos;
  } catch (e) {
    print(e);
    return [];
  }
}



Stream<List<Video>> getVideosByCategory(String category) {
  final videosRef = FirebaseFirestore.instance.collection('videos');

  final query = videosRef.where('category', isEqualTo: category);

  return query.snapshots().map((snapshot) {
    final videosData = snapshot.docs.map((doc) => doc.data()).toList();

    return videosData
        .map<Video>((videoData) => Video.fromMap(videoData))
        .toList();
  });
}

Future<List<Video>> getVideosByLocation(String location) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('videos')
      .where('location', isEqualTo: location)
      .get();

  final videos =
      querySnapshot.docs.map((doc) => Video.fromMap(doc.data())).toList();

  return videos;
}
