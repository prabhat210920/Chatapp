import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class userImagePicker extends StatefulWidget {
  const userImagePicker({
    super.key,
  required this.onPickImage});
  // final void

  final void Function(File _selectedImage) onPickImage;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _userImagePickerState();
  }
}

class _userImagePickerState extends State<userImagePicker> {
  File? _pickedImage;
  void _pickImage() async {
   final pickedImage  = await ImagePicker().pickImage(
       source: ImageSource.camera,
       imageQuality: 100,
       maxWidth: 150
   );
   if(pickedImage == null) return;
   setState(() {
     _pickedImage = File(pickedImage.path);
   });
   widget.onPickImage(_pickedImage!);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Add image', style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),),
          ),
        // )
      ],
    );
  }
}
