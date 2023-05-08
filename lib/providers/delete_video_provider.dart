import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:task/util/show_snack_bar.dart';

Future<void> deleteVideo(String id) async {
  try{
  final videoRef = FirebaseFirestore.instance.collection('videos').doc(id);

  // Get the URL of the video file from the Firestore document
  final videoSnapshot = await videoRef.get();
  final videoData = videoSnapshot.data();
  final videoUrl = videoData!['videoUrl'];

  // Delete the video file from Firebase Cloud Storage
  final videoReference = FirebaseStorage.instance.refFromURL(videoUrl);
  await videoReference.delete();

  // Delete the video document from Firestore
  await videoRef.delete();
  showPopupMessage("Video Deleted");

  }catch(e){
    showPopupMessage("Error while occured deleting video");
  }
}
