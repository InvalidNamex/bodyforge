import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '/widgets/trans_image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transformation_model.dart';
import '../constants.dart';

import '../controllers/coach_controller.dart';

class TransformationManagement extends GetView<CoachController> {
  const TransformationManagement({super.key});
  @override
  Widget build(BuildContext context) {
    controller.populateCoach();
    return Scaffold(
      backgroundColor: darkColor,
      body: Obx(
        () => controller.isLoading.value
            ? Center(
                child: SpinKitPumpingHeart(
                  color: accentColor,
                ),
              )
            : LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  if (constraints.maxWidth > pageWidth) {
                    return Center(
                      child: Container(
                        alignment: Alignment.topCenter,
                        width: pageWidth,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: buildContent(context, controller),
                      ),
                    );
                  } else {
                    return buildContent(context, controller);
                  }
                },
              ),
      ),
    );
  }

  Widget buildContent(context, CoachController controller) => Container(
      alignment: Alignment.topCenter,
      constraints: BoxConstraints(maxWidth: pageWidth),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(controller.coach!.coachImage),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(children: [
        AppBar(
          backgroundColor: darkColor.withOpacity(0.8),
          title: Text('New Transformation',
              style: GoogleFonts.aclonica(color: lightColor)),
          centerTitle: true,
        ),
        Form(
          key: controller.addTransformationFormKey,
          child: Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                // client name
                Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: accentColor),
                        color: darkColor.withOpacity(0.9)),
                    child: TextFormField(
                      style: TextStyle(color: lightColor),
                      controller: coachController.transName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: accentColor),
                        ),
                        labelText: 'Client Name',
                        labelStyle: TextStyle(color: lightColor),
                        prefixIcon: Icon(
                          Icons.person,
                          color: accentColor,
                        ),
                        hintText: 'Ahmed',
                        hintStyle: TextStyle(color: lightColor),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter client name';
                        }
                        return null;
                      },
                    )),
                // before image
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: accentColor),
                      color: darkColor.withOpacity(0.9)),
                  child: ListTile(
                    leading: Icon(
                      Icons.image,
                      color: accentColor,
                    ),
                    title: Text(
                      'Before Picture',
                      style: TextStyle(color: lightColor),
                    ),
                    trailing: transImagePicker(
                        isBefore: true,
                        coachID: controller.coach!.coachID,
                        before: coachController.transBefore,
                        after: coachController.transAfter),
                  ),
                ),
                // before image
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: accentColor),
                      color: darkColor.withOpacity(0.9)),
                  child: ListTile(
                    leading: Icon(
                      Icons.image,
                      color: accentColor,
                    ),
                    title: Text(
                      'After Picture',
                      style: TextStyle(color: lightColor),
                    ),
                    trailing: transImagePicker(
                        isBefore: false,
                        coachID: controller.coach!.coachID,
                        before: coachController.transBefore,
                        after: coachController.transAfter),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(accentColor)),
                    onPressed: () async {
                      try {
                        if (controller.addTransformationFormKey.currentState!
                            .validate()) {
                          if (coachController.transBefore.text != '' ||
                              coachController.transBefore.text.isNotEmpty) {
                            if (coachController.transAfter.text != '' ||
                                coachController.transAfter.text.isNotEmpty) {
                              Get.defaultDialog(
                                  title: '',
                                  content:
                                      SpinKitPumpingHeart(color: accentColor),
                                  backgroundColor: darkColor.withOpacity(0.7));
                              final supabase = Supabase.instance.client;
                              await supabase
                                  .from('transformation')
                                  .insert(TransformationModel(
                                    coachID: controller.coach!.coachID,
                                    before: coachController.transBefore.text,
                                    after: coachController.transAfter.text,
                                    name: coachController.transName.text,
                                  ))
                                  .whenComplete(() => Get.back());
                              coachController.transName.clear();
                              coachController.transBefore.clear();
                              coachController.transAfter.clear();
                              await coachController
                                  .deleteTrans(coachController.coach!.coachID);
                            }
                          }
                        } else {}
                      } catch (e) {
                        Get.back();
                        Get.snackbar('error', e.toString());
                      }
                    },
                    child: Text(
                      'Save Transformation',
                      style: TextStyle(
                          color: darkColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ]));
}
