import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:task/providers/auth_provider.dart';
import 'package:task/providers/video_file_provider.dart';
import 'package:task/providers/videos_by_title_provider.dart';
import 'package:task/util/search_bar.dart';
import 'package:task/views/videos/videoCard.dart';

import '../../models/video_model.dart';
import '../../providers/search_bar_provider.dart';
import '../../util/show_snack_bar.dart';

class VideoSearchScreen extends ConsumerStatefulWidget {
  const VideoSearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VideoSearchScreenState();
}

class _VideoSearchScreenState extends ConsumerState<VideoSearchScreen> {
  Future<List<Video>>? _futureVideos;
  ScrollController _scrollController = ScrollController();

  int _selectedIndex = 0;

  final List<String> _filters = [
    'All',
    'Location',
    'Autos & Vehicles',
    'Comedy',
    'Education',
    'Entertainment',
    'Film & Animation',
    'Gaming',
    'Howto & Style',
    'Music',
    'News & Politics',
    'Nonprofits & Activism',
    'People & Blogs',
    'Pets & Animals',
    'Science & Technology',
    'Sports',
    'Travel & Events'
  ];
  late final videoService;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoService = ref.read<VideoService>(videoServiceProvider);
  }

  String? _currentCity;

  late Position _currentPosition;

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
  Widget build(BuildContext context) {
    final searchTermController = ref.read(searchTermControllerProvider);
    final ayncValueVideos = ref.watch(videoByTitleProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomSearchBar(),
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SafeArea(
        child: ayncValueVideos.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) {
            return Center(child: Text('Error loading video: $stackTrace'));
          },
          data: (videos) {
            if (videos == null) {
              return Center(child: const Text('Videos not found'));
            } else {
              List<Video> filteredVideos = [];
              if (_selectedIndex == 0) {
                filteredVideos = videos;
              } else if (_selectedIndex == 1 && _currentCity != null) {
                filteredVideos = videos
                    .where((video) => video.location == _currentCity)
                    .toList();
              } else {
                String category = _filters[_selectedIndex];
                filteredVideos = videos
                    .where((video) => video.category == category)
                    .toList();
              }
              return Scrollbar(
                controller: _scrollController,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Chip(
                                      backgroundColor: _selectedIndex == index
                                          ? Colors.blue
                                          : Colors.white,
                                      label: Text(
                                        _filters[index],
                                        style: TextStyle(
                                          color: _selectedIndex == index
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      )),
                                ),
                              )),
                    ),
                    Expanded(
                      child: ListView.builder(
                          controller: _scrollController,
                          itemCount: filteredVideos.length,
                          itemBuilder: (context, index) {
                            final video = filteredVideos[index];
                            return VideoCard(video: video);
                          }),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
