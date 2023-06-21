import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

import '../constants.dart';

Widget transImagePicker({
  required int coachID,
  bool isBefore = false,
  required TextEditingController before,
  required TextEditingController after,
}) {
  final supabase = Supabase.instance.client;
  String bucket = 'transformations/${coachID.toString()}';
  RxBool isLoading = false.obs;
  return ElevatedButton(
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(accentColor)),
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
          isLoading(true);
          final _path = await supabase.storage.from(bucket).uploadBinary(
                '${isBefore ? 'before' : 'after'}/${DateTime.now().millisecondsSinceEpoch}.png',
                _image,
                fileOptions:
                    const FileOptions(cacheControl: '3600', upsert: false),
              );
          final uri = Uri.parse(_path);
          final fileName = uri.pathSegments.last;
          final subBucket = uri.pathSegments[2];
          final String publicUrl = supabase.storage
              .from(bucket)
              .getPublicUrl('$subBucket/$fileName');
          if (isBefore) {
            before.text = publicUrl;
          } else {
            after.text = publicUrl;
          }
          isLoading(false);
        }
      } catch (e) {
        Get.snackbar('Error', e.toString());
      }
    },
    child: Obx(
      () => !isLoading.value
          ? Text(
              'Choose Image',
              style: TextStyle(color: darkColor),
            )
          : Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: darkColor,
              ),
            ),
    ),
  );
}
