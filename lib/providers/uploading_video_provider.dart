import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:task/models/video_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../util/show_snack_bar.dart';

class VideoUploadService extends ChangeNotifier {
  double progress = 0;
  String title = "Video upload";
  double get getProgress => progress;

  void get getTitle => title;
  void setTitle(String s) {
    title = s;
    notifyListeners();
  }

  void increment(double count) {
    progress = count;
    notifyListeners();
  }

  void reset(double count) {
    progress = count;
    notifyListeners();
  }

  Future<void> addVideo(File videoFile, File thumbnailFile, String title,
      String category, String uploaderProfileId,String description , String photoUrl ,String userName, String location) async {
    setTitle("Video upload");
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final videoFileName = path.basename(videoFile.path);
      final thumbnailFileName = path.basename(thumbnailFile.path);

      // Upload the video file and its thumbnail to Firebase Storage
      final videoTask =
          storageRef.child('videos/$videoFileName').putFile(videoFile);
      final thumbnailTask = storageRef
          .child('thumbnails/$thumbnailFileName')
          .putFile(thumbnailFile);

      // Display upload progress for the video file
      setTitle("Uploading video");
      videoTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;

        increment(progress * 100);

        print('Video upload progress: ${progress.toStringAsFixed(2)}');
      });

      reset(0);

      // Display upload progress for the thumbnail file
      setTitle("Uploading Thumbnail");

      thumbnailTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;

        increment(progress * 100);

        print('Thumbnail upload progress: ${progress.toStringAsFixed(2)}');
      });

      // Wait for both uploads to complete
      final tasks = await Future.wait([videoTask, thumbnailTask]);

      // Get the URLs of the uploaded files
      final videoUrl = await videoTask.snapshot.ref.getDownloadURL();
      final thumbnailUrl = await thumbnailTask.snapshot.ref.getDownloadURL();

      // Create the Firestore document for the video
      final videosRef = FirebaseFirestore.instance.collection('videos');
      final videoDocRef = videosRef.doc();

      final video = Video(
        id: videoDocRef.id,
        title: title,
        category: category,
        uploaderProfileId: uploaderProfileId,
        date: DateTime.now(),
        thumbnailUrl: thumbnailUrl,
        // Initialize other fields with default values
        likes: 0,
        dislikes: 0,
        views: 0,
        comments: [],
        videoUrl: '',
        location: location,
      );

      // Save the video document to Firestore
      await videoDocRef.set(video.toMap());

      // Update the video document with the URL of the video file
      await videoDocRef.update({'videoUrl': videoUrl});

      // Display completion message
      setTitle("Uploading completed");

      showPopupMessage('Video uploaded successfully!');
    } catch (e) {
      showPopupMessage('Video uploaded failed ! $e');
    }
  }
}

final videoUploadProvider =
    ChangeNotifierProvider<VideoUploadService>((ref) => VideoUploadService());
