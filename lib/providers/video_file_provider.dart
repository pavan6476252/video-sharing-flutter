

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoService extends ChangeNotifier{
  XFile ? videoFile;
  String ? location;


  XFile? getVideoFile() =>videoFile;
  void setVideoFile  (video)=>videoFile =video;

  String? getLocation ()=>location;
  void setLocation (String s) => location =s;
}

final videoServiceProvider = Provider<VideoService>((ref) {
  return VideoService();
});