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
          title:
              Text('NEW PLAN', style: GoogleFonts.aclonica(color: lightColor)),
          centerTitle: true,
        ),
        Form(
          key: controller.addPlanFormKey,
          child: Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: accentColor),
                        color: darkColor.withOpacity(0.9)),
                    child: TextFormField(
                      style: TextStyle(color: lightColor),
                      controller: controller.planName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: accentColor),
                        ),
                        labelText: 'Plan name',
                        labelStyle: TextStyle(color: lightColor),
                        prefixIcon: Icon(
                          Icons.abc,
                          color: accentColor,
                        ),
                        hintText: 'Silver',
                        hintStyle: TextStyle(color: lightColor),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter plan name';
                        }
                        return null;
                      },
                    )),
                Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: accentColor),
                        color: darkColor.withOpacity(0.9)),
                    child: TextFormField(
                      style: TextStyle(color: lightColor),
                      controller: controller.planTitle,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: accentColor),
                        ),
                        labelText: 'Second line',
                        labelStyle: TextStyle(color: lightColor),
                        prefixIcon: Icon(
                          Icons.abc,
                          color: accentColor,
                        ),
                        hintText: 'Together better',
                        hintStyle: TextStyle(color: lightColor),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter plan title';
                        }
                        return null;
                      },
                    )),
                Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: accentColor),
                        color: darkColor.withOpacity(0.9)),
                    child: TextFormField(
                      maxLines: 7,
                      style: TextStyle(color: lightColor),
                      controller: controller.planText,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: accentColor),
                          ),
                          labelText: 'Plan details',
                          labelStyle: TextStyle(color: lightColor),
                          prefixIcon: Icon(
                            Icons.abc,
                            color: accentColor,
                          ),
                          hintText:
                              'Custom diet and workout plan \n Weekly follow up',
                          hintStyle: TextStyle(color: lightColor)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter plan details';
                        }
                        return null;
                      },
                    )),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: accentColor),
                      color: darkColor.withOpacity(0.9)),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: lightColor),
                    controller: controller.planPrice,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: accentColor),
                      ),
                      labelText: 'plan price',
                      labelStyle: TextStyle(color: lightColor),
                      prefixIcon: Icon(
                        Icons.abc,
                        color: accentColor,
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
                  margin: const EdgeInsets.all(20),
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(accentColor)),
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
                    child: Text(
                      'Save Plan',
                      style: TextStyle(color: darkColor),
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Divider(
                      height: 10,
                      color: accentColor,
                      thickness: 2,
                    ),
                    Center(
                        child: Text(
                      'OR',
                      style: TextStyle(color: lightColor, fontSize: 28),
                    )),
                  ],
                ),
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
                      'Plan Picture',
                      style: TextStyle(color: lightColor),
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
