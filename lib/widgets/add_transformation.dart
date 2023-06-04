import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '/widgets/plan_image_picker.dart';
import '../constants.dart';

import '../controllers/coach_controller.dart';

class TransformationManagement extends GetView<CoachController> {
  const TransformationManagement({super.key});
  @override
  Widget build(BuildContext context) {
    controller.populateCoach();
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/coach-cpanel');
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Obx(
          () => controller.isLoading.value
              ? const Center(
                  child: SpinKitPumpingHeart(
                    color: Colors.red,
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
          backgroundColor: Colors.black.withOpacity(0.8),
          title: Text('New Transformation',
              style: GoogleFonts.aclonica(color: Colors.white)),
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
                        border: Border.all(color: Colors.red),
                        color: Colors.black.withOpacity(0.9)),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: controller.transName,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        labelText: 'Client Name',
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.red,
                        ),
                        hintText: 'Ahmed',
                        hintStyle: TextStyle(color: Colors.white),
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
                      border: Border.all(color: Colors.red),
                      color: Colors.black.withOpacity(0.9)),
                  child: ListTile(
                    leading: const Icon(
                      Icons.image,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Before Picture',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: planImagePicker(
                      buttonText: 'Choose Image',
                      imageBucket: 'pricing',
                      dataTable: 'price-plans',
                      coachID: controller.coach!.coachID,
                    ),
                  ),
                ),
                // before image
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red),
                      color: Colors.black.withOpacity(0.9)),
                  child: ListTile(
                    leading: const Icon(
                      Icons.image,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'After Picture',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: planImagePicker(
                      buttonText: controller.transAfter.text.isEmpty
                          ? 'Choose Image'
                          : 'Done',
                      imageBucket: 'pricing',
                      dataTable: 'price-plans',
                      coachID: controller.coach!.coachID,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red)),
                    onPressed: () async {
                      if (controller.addPlanFormKey.currentState!.validate()) {
                        final planName = controller.planName.text;
                        final planTitle = controller.planTitle.text;
                        final planText = controller.planText.text;
                        final planPrice = controller.planPrice.text;

                        await controller
                            .addPlan(planName, planTitle, planText,
                                int.parse(planPrice))
                            .whenComplete(() => Get.snackbar('Trans Saved',
                                'Your new trans was saved successfully'));
                        controller.planName.clear();
                        controller.planTitle.clear();
                        controller.planText.clear();
                        controller.planPrice.clear();
                      }
                    },
                    child: const Text('Save Transformation'),
                  ),
                )
              ],
            ),
          ),
        )
      ]));
}
