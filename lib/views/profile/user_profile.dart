import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task/providers/auth_provider.dart';
import 'package:task/util/cached_image.dart';
import 'package:task/util/show_snack_bar.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  String? _userName;
  XFile? pickedImage;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> pickImage(ImageSource gallery) async {
    final ImagePicker picker = ImagePicker();
    pickedImage = await picker.pickImage(source: gallery);
    setState(() {});
  }

  Widget _buildProfileAvatar(BuildContext context, String? photoURL) {
    return Stack(
      children: [
        pickedImage != null
            ? CircleAvatar(radius: 60.0,
             backgroundColor: Colors.white,
             backgroundImage: FileImage(File(pickedImage!.path)))
            : CircleAvatar(
                radius: 60,
                backgroundImage: CachedNetworkImageProvider(
                    photoURL ??
                        "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541",
                    errorListener: () {}),
              ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                onPressed: () => showModalBottomSheet(
                      context: context,
                      builder: (_) => BottomSheet(
                        onClosing: () {},
                        builder: (_) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Choose from library'),
                              onTap: () {
                                pickImage(ImageSource.gallery);
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_camera),
                              title: const Text('Take a photo'),
                              onTap: () {
                                pickImage(ImageSource.camera);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    )),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch<AuthService>(authProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        actions: [
          _userName != null || pickedImage != null
              ? IconButton(
                  onPressed: () async {
                    try {
                      await authService.updateProfile(_userName, pickedImage);
                      showSnackBar(context, 'updated successfully');
                      _userName = null;
                      pickedImage = null;
                      setState(() {});
                    } catch (e) {
                      showSnackBar(context, e.toString(), isError: true);
                    }
                  },
                  icon: const Icon(Icons.save))
              : const SizedBox.shrink()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildProfileAvatar(context, authService.currentUser.photoURL),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: authService.currentUser.displayName,
                  decoration: const InputDecoration(
                    labelText: 'User Name',
                    hintText: 'Enter your user name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid user name';
                    }
                    return null;
                  },
                  onChanged: (value) => _userName = value,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await authService.signOut();
                    Navigator.pop(context);
                  },
                  child: const Text("Sign Out"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
