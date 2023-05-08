import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task/providers/video_file_provider.dart';
import 'package:task/util/show_snack_bar.dart';
import 'package:task/views/upload/upload_page.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoRecorderScreen extends ConsumerStatefulWidget {
  const VideoRecorderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VideoRecorderScreenState();
}

@override
_VideoRecorderScreenState createState() => _VideoRecorderScreenState();

class _VideoRecorderScreenState extends ConsumerState<VideoRecorderScreen> {
  CameraController? _cameraController;
  String _videoPath = '';
  bool _isRecording = false;
  bool _isPaused = false;
  late Timer _timer;
  Duration _videoDuration = Duration.zero;
  String _videoFileSize = '';
  late LatLng _currentLocation;
  late int _selectedCameraIndex;
  late List<CameraDescription> cameras;

  final picker = ImagePicker();

  Future<void> pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        videoService.setVideoFile(pickedFile);
      } else {
        print('No video selected.');
      }
    });
  }

  void switchCamera() {
    _selectedCameraIndex = (_selectedCameraIndex + 1) % cameras.length;
    _cameraController = CameraController(
      cameras[_selectedCameraIndex],
      ResolutionPreset.high,
    );
    _cameraController!.initialize().then((_) {
      setState(() {});
    });
  }

  Future<void> _initializeCameraController() async {
    cameras = await availableCameras();
    _selectedCameraIndex = 0;
    _cameraController = CameraController(
      cameras[_selectedCameraIndex],
      ResolutionPreset.high,
    );
    await _cameraController!.initialize();
    setState(() {});
  }

  Future<void> _startVideoRecording() async {
    if (!_cameraController!.value.isInitialized) {
      return;
    }
    final videoDirectory = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '$timestamp.mp4';
    _videoPath = '${videoDirectory.path}/$fileName';
    await _cameraController!.startVideoRecording();
    _isRecording = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _videoDuration = Duration(seconds: _videoDuration.inSeconds + 1);
      });
    });
  }

  late final videoService;

  Future<void> _stopVideoRecording() async {
    if (_cameraController!.value.isRecordingVideo) {
      try {
        videoService
            .setVideoFile(await _cameraController!.stopVideoRecording());
        _isRecording = false;
        _timer.cancel();
        final videoFile = File(videoService.getVideoFile()!.path);
        final videoSize = await videoFile.length();
        setState(() {
          _videoDuration = Duration.zero;
          _videoFileSize = '${(videoSize / 1024 / 1024).toStringAsFixed(2)} MB';
          _isPaused = false;
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void _pauseVideoRecording() {
    _cameraController!.pauseVideoRecording();
    _isPaused = true;
    _timer.cancel();
  }

  void _resumeVideoRecording() {
    _cameraController!.resumeVideoRecording();
    _isPaused = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _videoDuration = Duration(seconds: _videoDuration.inSeconds + 1);
      });
    });
  }

  late Position _currentPosition;
  String? _currentCity;

  Future<void> _getCurrentLocation() async {
    await Geolocator.requestPermission();

    LocationPermission geolocationStatus = await Geolocator.requestPermission();
    if (geolocationStatus == LocationPermission.denied) {
      showPopupMessage("Permission denied");
      Navigator.pop(context);
    }

    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition.latitude, _currentPosition.longitude);

    Placemark place = placemarks[0];
    _currentCity = place.locality;
    videoService.setLocation(_currentCity);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    videoService = ref.read<VideoService>(videoServiceProvider);
    _initializeCameraController();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _cameraController!.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Recorder'),
        actions: [
          IconButton(
              onPressed: () {
                pickVideo();
              },
              icon: Icon(Icons.video_camera_back_outlined)),
          Chip(label: Text(_currentCity ?? "Unknown"))
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 10,
            child: _cameraController != null
                ? AspectRatio(
                    aspectRatio: _cameraController!.value.aspectRatio,
                    child: CameraPreview(_cameraController!),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          Expanded(
            flex: 1,
            child: CameraBottomBar(
              switchCamera: switchCamera,
              isRecording: _isRecording,
              isPaused: _isPaused,
              onStartRecording: _startVideoRecording,
              onStopRecording: _stopVideoRecording,
              onPauseRecording: _pauseVideoRecording,
              onResumeRecording: _resumeVideoRecording,
              onStoreVideo: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UploadPage(),
                    ));
              },
              videoDuration: _videoDuration,
              videoFile: videoService.getVideoFile(),
            ),
          )
        ],
      ),
    );
  }
}

class CameraBottomBar extends StatelessWidget {
  final bool isRecording;
  final bool isPaused;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;
  final VoidCallback onPauseRecording;
  final VoidCallback onResumeRecording;
  final VoidCallback onStoreVideo;

  final VoidCallback switchCamera;
  final Duration videoDuration;
  final XFile? videoFile;

  CameraBottomBar({
    required this.switchCamera,
    required this.isRecording,
    required this.isPaused,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onPauseRecording,
    required this.onResumeRecording,
    required this.onStoreVideo,
    required this.videoDuration,
    required this.videoFile,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.camera_rear_rounded),
            color: Colors.white,
            onPressed: () {
              switchCamera();
            },
          ),
          isRecording
              ? IconButton(
                  icon: const Icon(Icons.stop),
                  color: Colors.red,
                  onPressed: onStopRecording,
                )
              : IconButton(
                  icon: const Icon(Icons.fiber_manual_record),
                  color: Colors.red,
                  onPressed: onStartRecording,
                ),
          isPaused
              ? IconButton(
                  icon: const Icon(Icons.play_arrow),
                  color: Colors.white,
                  onPressed: onResumeRecording,
                )
              : IconButton(
                  icon: const Icon(Icons.pause),
                  color: Colors.white,
                  onPressed: onPauseRecording,
                ),
          videoDuration == Duration.zero
              ? videoFile != null
                  ? Chip(
                      label: const Text("Post"),
                      deleteIcon: const Icon(Icons.upload_outlined),
                      onDeleted: () => onStoreVideo())
                  : Chip(label: Text(videoDuration.toString()))
              : Chip(label: Text(videoDuration.toString())),
        ],
      ),
    );
  }
}
