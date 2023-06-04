import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

Widget imagePicker({
  required String url,
  required String buttonText,
  required String imageBucket,
  required String dataTable,
  required String column,
  required String value,
}) {
  final supabase = Supabase.instance.client;

  return ElevatedButton(
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
    onPressed: () async {
      try {
        final picker = ImagePicker();
        Uint8List _image;
        PickedFile? pickedFile =
            await picker.getImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          if (kIsWeb) {
            _image = await pickedFile.readAsBytes();
          } else {
            _image = await pickedFile.readAsBytes();
          }
          final uri = Uri.parse(url);
          final fileName = uri.pathSegments.last;
          await supabase.storage.from(imageBucket).updateBinary(
                fileName,
                _image,
                fileOptions:
                    const FileOptions(cacheControl: '3600', upsert: false),
              );
        }
      } catch (e) {
        Get.snackbar('Error', e.toString());
        print(e.toString());
      }
    },
    child: Text(
      buttonText,
      style: const TextStyle(color: Colors.white),
    ),
  );
}
