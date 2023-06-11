import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import '/widgets/plan_image_picker.dart';

import '../controllers/coach_controller.dart';

class PricePlan extends GetView<CoachController> {
  const PricePlan({super.key});
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
          title: Text('NEW PLAN',
              style: GoogleFonts.aclonica(color: Colors.white)),
          centerTitle: true,
        ),
        Form(
          key: controller.addPlanFormKey,
          child: Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                // plan name
                Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red),
                        color: Colors.black.withOpacity(0.9)),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: controller.planName,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        labelText: 'Plan name',
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.abc,
                          color: Colors.red,
                        ),
                        hintText: 'Silver',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter plan name';
                        }
                        return null;
                      },
                    )),
                // plan title
                Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red),
                        color: Colors.black.withOpacity(0.9)),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: controller.planTitle,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        labelText: 'Second line',
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.abc,
                          color: Colors.red,
                        ),
                        hintText: 'Together better',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter plan title';
                        }
                        return null;
                      },
                    )),
                // plan text
                Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red),
                        color: Colors.black.withOpacity(0.9)),
                    child: TextFormField(
                      maxLines: 7,
                      style: const TextStyle(color: Colors.white),
                      controller: controller.planText,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          labelText: 'Plan details',
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.abc,
                            color: Colors.red,
                          ),
                          hintText:
                              'Custom diet and workout plan \n Weekly follow up',
                          hintStyle: TextStyle(color: Colors.white)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter plan details';
                        }
                        return null;
                      },
                    )),
                // plan price
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red),
                      color: Colors.black.withOpacity(0.9)),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    controller: controller.planPrice,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      labelText: 'plan price',
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.abc,
                        color: Colors.red,
                      ),
                      hintText: 'Enter plan price',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter plan price';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
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
                            .whenComplete(() => Get.snackbar('Plan Saved',
                                'Your new plan was saved successfully'));
                        controller.planName.clear();
                        controller.planTitle.clear();
                        controller.planText.clear();
                        controller.planPrice.clear();
                      }
                    },
                    child: const Text('Save Plan'),
                  ),
                ),
                const Stack(
                  alignment: Alignment.center,
                  children: [
                    Divider(
                      height: 10,
                      color: Colors.red,
                      thickness: 2,
                    ),
                    Center(
                        child: Text(
                      'OR',
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    )),
                  ],
                ),
                // plan image
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
                      'Plan Picture',
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
              ],
            ),
          ),
        )
      ]));
}
