import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:vit_buzz_bytes/constants/server.dart';
import 'package:vit_buzz_bytes/providers/token_provider.dart';
import 'package:path/path.dart' as path;

class ProfileImage extends ConsumerStatefulWidget {
  final String networkImageUrl;
  final Function profilePicSetter;
  final bool isEditable;
  const ProfileImage(
      {Key? key,
      required this.networkImageUrl,
      required this.profilePicSetter,
      required this.isEditable})
      : super(key: key);
  @override
  ConsumerState<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends ConsumerState<ProfileImage> {
  File? imageFile;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
          Permission.camera,
        ].request();
        if (statuses[Permission.storage]!.isGranted &&
            statuses[Permission.camera]!.isGranted &&
            context.mounted) {
          showImagePicker(context);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Permissions not granted'),
                content: const Text(
                    'This app needs storage and camera permissions to function correctly.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ask Again'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      [Permission.storage, Permission.camera].request();
                    },
                  ),
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      child: widget.networkImageUrl.isEmpty
          ? Center(
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 75,
                child: Icon(Icons.person,
                    size: 75, color: Theme.of(context).colorScheme.surface),
              ),
            )
          : imageFile == null
              ? CircleAvatar(
                  radius: 75, // Adjust the radius as needed
                  backgroundImage: NetworkImage(widget.networkImageUrl),
                )
              : CircleAvatar(
                  radius: 75,
                  backgroundImage: FileImage(imageFile!),
                ),
    );
  }

  final picker = ImagePicker();

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Card(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5.2,
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.image,
                            size: 60.0,
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            "Gallery",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onSurface),
                          )
                        ],
                      ),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.pop(context);
                      },
                    )),
                    Expanded(
                        child: InkWell(
                      child: SizedBox(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.camera_alt,
                              size: 60.0,
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              "Camera",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        _imgFromCamera();
                        Navigator.pop(context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  _imgFromGallery() async {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  _imgFromCamera() async {
    await picker
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        maxWidth: 200,
        maxHeight: 200,
        uiSettings: [
          IOSUiSettings(
            title: 'Crop Image',
          ),
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Theme.of(context).colorScheme.surface,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
        ]);

    if (croppedFile != null) {
      imageCache.clear();
      setState(() {
        imageFile = File(croppedFile.path);
      });

      // Create a multipart request
      var request = http.MultipartRequest(
          'PATCH', Uri.parse('$server/api/v1/users/edit-profile'));
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Authorization':
            'Bearer ${ref.read(tokenProvider)}', // replace with your actual token
      });
      // Attach the file to the request
      // Get the file extension
      String extension = path.extension(croppedFile.path).toLowerCase();

      // Set the content type based on the file extension
      MediaType contentType;
      if (extension == '.jpg' || extension == '.jpeg') {
        contentType = MediaType('image', 'jpeg');
      } else if (extension == '.png') {
        contentType = MediaType('image', 'png');
      } else {
        throw Exception('Unsupported file type');
      }
// Get the last element of networkImageUrl.split('/')
      String oldProfilePic = widget.networkImageUrl.split('/').last;

// Add oldProfilePic to the request body
      request.fields['oldProfilePic'] = oldProfilePic;

// The rest of your code...
      request.files.add(await http.MultipartFile.fromPath(
        'photo',
        croppedFile.path,
        contentType: contentType,
      ));
      // Send the request
      var response = await request.send();

      // Listen for the response
      response.stream.transform(utf8.decoder).listen((value) {
        var decodedData = jsonDecode(value);

        if (decodedData['status'] == 'success') {
          setState(() {
            widget.profilePicSetter(
                '$server/api/v1/users/img/${decodedData['data']['profilePic']}');
          });
        }
      });
    }
  }
}
