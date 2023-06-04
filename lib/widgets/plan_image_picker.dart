import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ifit/constants.dart';
import 'package:ifit/models/pricing_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

Widget planImagePicker({
  required String buttonText,
  required String imageBucket,
  required String dataTable,
  required int coachID,
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
          Get.defaultDialog(
              backgroundColor: Colors.black.withOpacity(0.7),
              title: '',
              content: const SpinKitPumpingHeart(
                color: Colors.red,
              ));
          final _path = await supabase.storage.from(imageBucket).uploadBinary(
                '$coachID/${DateTime.now().millisecondsSinceEpoch}.png',
                _image,
                fileOptions:
                    const FileOptions(cacheControl: '3600', upsert: false),
              );
          final uri = Uri.parse(_path);
          final bucketId = uri.pathSegments[1];
          final fileName = uri.pathSegments.last;
          final String publicUrl = supabase.storage
              .from(imageBucket)
              .getPublicUrl('$bucketId/$fileName');
          await supabase
              .from(dataTable)
              .insert(PricingModel(coachID: coachID, planImage: publicUrl))
              .whenComplete(() => Get.back());
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
