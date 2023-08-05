import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class imagewidget extends StatefulWidget {
  const imagewidget({super.key, required this.getpickedimage});
  final void Function(File pickedimage) getpickedimage;
  @override
  State<imagewidget> createState() => _imagewidgetState();
}

/////////////////////////////////////////////////////////////////
///////////uploading image///////////////////////////////////////
class _imagewidgetState extends State<imagewidget> {
  File? pickedimagefile;

  void pickimage() async {
    final pickedimage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedimage == null) {
      return;
    }
    setState(() {
      pickedimagefile = File(pickedimage.path);
    });

    widget.getpickedimage(pickedimagefile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              //////////fileimage=provider wherease file.image is a widget
              pickedimagefile != null ? FileImage(pickedimagefile!) : null,
        ),
        TextButton.icon(
          onPressed: pickimage,
          icon: Icon(Icons.image),
          label: Text(
            "upload image",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
