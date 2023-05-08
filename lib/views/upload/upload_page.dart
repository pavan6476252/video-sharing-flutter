import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:task/providers/uploading_video_provider.dart';
import 'package:task/providers/auth_provider.dart';
import 'package:task/providers/video_file_provider.dart';
import 'package:task/util/show_snack_bar.dart';

// import 'package:video_thumbnail/video_thumbnail.dart';

class UploadPage extends ConsumerStatefulWidget {
  const UploadPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadPageState();
}

class _UploadPageState extends ConsumerState<UploadPage> {
  File? _image;
  final picker = ImagePicker();
  String _category = 'Howto & Style';

  late final videoService;
  final TextEditingController _locationController = TextEditingController();
  @override
  void initState() {
    super.initState();

    videoService = ref.read<VideoService>(videoServiceProvider);
    _locationController.text = videoService.getLocation();
    // generateThubnail();
  }
  // generateThubnail() async {
  //   final uint8list = await VideoThumbnail.thumbnailData(
  //     video: videoService.getVideoFile()!.path,
  //     imageFormat: ImageFormat.JPEG,
  //     maxWidth:
  //         300, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
  //     maxHeight: 200,
  //     quality: 25,
  //   );
  //   _image = File.fromRawPath(uint8list!);
  //   setState(() {});
  // }

  final _categories = [
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

  @override
  Widget build(BuildContext context) {
    final videoUploadService = ref.watch(videoUploadProvider);

    final authService = ref.read(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Video'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // VideoPlayerPage(videoFile: videoService.getVideoFile()),
            _buildThumbnail(),
            _buildTitle(),
            _builLocation(),
           
            _buildDescription(),
            _buildCategory(),
            ElevatedButton(
              onPressed: () {
                if (_image == null) {
                  showSnackBar(context, "Please Provide Thumbnail",
                      isError: true);
                  return;
                }
                videoUploadService.addVideo(
                  File(videoService.getVideoFile().path),
                  _image!,
                  _titleController.text,
                  _category,
                  authService.currentUser.uid,
                  videoService.getLocation(),
                );
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Alert(),
                    ));
              },
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: GestureDetector(
        onTap: () => _getImage(),
        child: _image == null
            ? Container(
                height: 200,
                width: double.maxFinite,
                color: const Color.fromARGB(255, 164, 164, 164),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.image_outlined,
                      size: 50,
                    ),
                    Text("Choose thubnail")
                  ],
                ),
              )
            : Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(_image!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _getImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _titleController,
        decoration: const InputDecoration(
          labelText: 'Title',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _descriptionController,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
          labelText: 'Description',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildCategory() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: DropdownSearch<String>(
          items: _categories,
          onChanged: (value) {
            setState(() {
              _category = value!;
            });
          },
          selectedItem: _category,
        ),
      ),
    );
  }

  void _uploadVideo() {
    // videoUploadService.addVideo(
    //   File(videoService.getVideoFile().path),
    //   _image!,
    //   _titleController.text,
    //   _category,
    //   authService.currentUser.uid,
    //   videoService.getLocation(),
    // // );

    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //         title: Text('Uploading Video...'),
    //         content: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             LinearProgressIndicator(
    //               value: (videoUploadService.uploadProgress),
    //             ),
    //             SizedBox(height: 16),
    //             Text('Upload Progress: ${videoUploadService.uploadProgress}'),
    //           ],
    //         ));
    //   },
    // );
    //  Navigator.pop(context);
    // if (videoUploadService.isSuccess!) {

    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Video upload completed successfully!')),
    //   );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Video upload failed.')),
    //   );
    // }
  }

  _builLocation() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _locationController,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
          labelText: 'Location',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class Alert extends ConsumerWidget {
  const Alert({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoUploadService = ref.watch(videoUploadProvider);

    return Scaffold(
      body: Center(
          child: Card(
              child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(videoUploadService.title),
          ListTile(
            title: Text('${videoUploadService.progress} %'),
            subtitle: LinearProgressIndicator(
              value: videoUploadService.progress,
            ),
            trailing: const Icon(Icons.upload),
          ),
          const Text("background uploading supported")
        ],
      ))),
    );
  }
}
