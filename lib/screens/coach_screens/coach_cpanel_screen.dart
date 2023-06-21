import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/exercise_model.dart';
import '../../widgets/coach_image_picker.dart';
import '../../widgets/scaffold_widget.dart';
import '/controllers/coach_controller.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class CoachCPanel extends GetView<CoachController> {
  const CoachCPanel({super.key});

  @override
  Widget build(BuildContext context) {
    controller.populateCoach();
    return WillPopScope(
        onWillPop: () async {
          Get.offNamed('/coach-zone');
          return true;
        },
        child: MyScaffold(buildContent: buildContent(context, controller)));
  }
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
      child: Column(
        children: [
          AppBar(
            backgroundColor: darkColor.withOpacity(0.8),
            title: Text('Control Panel',
                style: GoogleFonts.aclonica(color: lightColor)),
            centerTitle: true,
          ),
          Expanded(
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
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: accentColor,
                    ),
                    title: Text(
                      'Change Picture',
                      style: TextStyle(color: lightColor),
                    ),
                    trailing: imagePicker(
                      url: controller.coach!.coachImage,
                      buttonText: 'Choose Image',
                      imageBucket: 'coach_image',
                      dataTable: 'coaches',
                      column: 'id',
                      value: controller.coach!.coachID.toString(),
                    ),
                  ),
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
                      Icons.password,
                      color: accentColor,
                    ),
                    title: Text(
                      'Change Password',
                      style: TextStyle(color: lightColor),
                    ),
                    onTap: () {
                      Get.defaultDialog(
                          backgroundColor: darkColor.withOpacity(0.9),
                          title: 'Change Password',
                          titleStyle: TextStyle(color: lightColor),
                          content: Form(
                            key: controller.changePasswordFormKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  style: TextStyle(color: lightColor),
                                  autofocus: true,
                                  onEditingComplete: () =>
                                      controller.validatePassword(),
                                  obscureText: true,
                                  controller: controller.coachPassword,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: accentColor),
                                    ),
                                    hintText: 'Enter password',
                                    hintStyle: TextStyle(color: lightColor),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(color: lightColor),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: accentColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              accentColor)),
                                  onPressed: () async {
                                    final supabase = Supabase.instance.client;
                                    await supabase.from('coaches').update({
                                      'coach_password':
                                          controller.coachPassword.text
                                    }).eq('id', controller.coach!.coachID);
                                    Get.back();
                                  },
                                  child: Text(
                                    'Save Password',
                                    style: TextStyle(color: darkColor),
                                  ),
                                )
                              ],
                            ),
                          ));
                    },
                  ),
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
                        Icons.videocam_outlined,
                        color: accentColor,
                      ),
                      title: Text(
                        'Add Tutorial Video',
                        style: TextStyle(color: lightColor),
                      ),
                      onTap: () => addTutorialVideo(controller.coach!.coachID)),
                ),
                managePlans(controller, context),
                manageTransformations(controller, context),
              ],
            ),
          ),
        ],
      ),
    );

Widget managePlans(CoachController controller, context) {
  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor),
        color: darkColor.withOpacity(0.9)),
    child: ExpansionTile(
      iconColor: accentColor,
      collapsedIconColor: lightColor,
      collapsedTextColor: lightColor,
      leading: IconButton(
          onPressed: () => Get.toNamed('/add-plan'),
          icon: Icon(
            Icons.add,
            color: lightColor,
          )),
      title: Text(
        'Plans & Offers',
        style: GoogleFonts.aclonica(color: lightColor),
      ),
      children: <Widget>[
        Obx(
          () => controller.pricingList.isEmpty
              ? SpinKitPumpingHeart(
                  color: accentColor,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.pricingList
                      .where((item) => item.planName != null)
                      .toList()
                      .length,
                  itemBuilder: (context, index) => ListTile(
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: accentColor,
                      ),
                      onPressed: () async {
                        await controller.deletePlan(controller.pricingList
                            .where((item) => item.planName != null)
                            .toList()[index]
                            .planID!);
                      },
                    ),
                    title: Text(
                      controller.pricingList
                          .where((item) => item.planName != null)
                          .toList()[index]
                          .planName!,
                      style: TextStyle(color: accentColor),
                    ),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${controller.pricingList.where((item) => item.planName != null).toList()[index].planTitle}',
                          style: TextStyle(
                              color: lightColor, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(
                            'Price: ${controller.pricingList.where((item) => item.planName != null).toList()[index].planPrice}',
                            style: TextStyle(
                                color: lightColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    ),
  );
}

Widget manageTransformations(CoachController controller, context) {
  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor),
        color: darkColor.withOpacity(0.9)),
    child: ExpansionTile(
      iconColor: accentColor,
      collapsedIconColor: lightColor,
      collapsedTextColor: lightColor,
      leading: IconButton(
          onPressed: () => Get.toNamed('/add-transformation'),
          icon: Icon(
            Icons.add,
            color: lightColor,
          )),
      title: Text(
        'Transformations',
        style: GoogleFonts.aclonica(color: lightColor),
      ),
      children: <Widget>[
        Obx(
          () => controller.transList.isEmpty
              ? SpinKitPumpingHeart(
                  color: accentColor,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.transList.length,
                  itemBuilder: (context, index) => ListTile(
                    trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: accentColor,
                        ),
                        onPressed: () async {
                          await controller.deleteTrans(
                              controller.transList[index].transformationID!);
                        }),
                    title: Text(
                      '${controller.transList[index].name}',
                      style: TextStyle(color: accentColor),
                    ),
                  ),
                ),
        ),
      ],
    ),
  );
}

Future addTutorialVideo(coach) async {
  final createWorkoutUrl = TextEditingController();
  final createWorkoutTitle = TextEditingController(text: 'Bench press');
  final createWorkoutKey = GlobalKey<FormState>();

  await workoutController.getExercisesByMuscleGroup('Chest');
  workoutController.workoutTitle.text = 'Bench press';
  Get.defaultDialog(
      title: 'Add Video',
      titleStyle: GoogleFonts.lato(color: lightColor),
      backgroundColor: darkColor.withOpacity(0.9),
      content: Form(
        key: createWorkoutKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(50)),
              child: DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                  disabledItemFn: (String s) => s.startsWith('X'),
                ),
                items: const [
                  "Chest",
                  "Back",
                  "Shoulder",
                  "Triceps",
                  "Biceps",
                  "Leg",
                  "Cardio & abs"
                ],
                dropdownDecoratorProps: DropDownDecoratorProps(
                  baseStyle: TextStyle(color: lightColor),
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Muscle Group",
                    labelStyle: TextStyle(color: lightColor),
                    hintText: "Choose a muscle to train",
                    hintStyle: TextStyle(color: lightColor),
                  ),
                ),
                onChanged: (String? muscle) async {
                  await workoutController.getExercisesByMuscleGroup(muscle);
                },
                selectedItem: "Chest",
              ),
            ),
            Obx(
              () => Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(50)),
                child: DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSelectedItems: true,
                    disabledItemFn: (String s) => s.startsWith('X'),
                  ),
                  items: workoutController.exercisesList
                      .map((ExerciseModel model) => model.exercise)
                      .toList(),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Exercise",
                      hintText: "Choose an exercise",
                    ),
                  ),
                  onChanged: (String? muscle) {
                    createWorkoutTitle.text = muscle ?? 'Bench press';
                  },
                  selectedItem: 'Bench press',
                ),
              ),
            ),
            TextFormField(
              style: TextStyle(color: lightColor),
              controller: createWorkoutUrl,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: accentColor),
                    borderRadius: BorderRadius.circular(50)),
                labelText: 'workout url',
                labelStyle: TextStyle(color: lightColor),
                hintText: 'https://www.instagram.com/reel/CsjLMqwuYyn/',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter workout link';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(accentColor)),
                onPressed: () async {
                  if (createWorkoutKey.currentState!.validate()) {
                    await workoutController.createWorkout(
                      coach: coach,
                      url: createWorkoutUrl.text,
                      exercise: createWorkoutTitle.text,
                    );
                    createWorkoutTitle.clear();
                    createWorkoutUrl.clear();
                    Get.back();
                  }
                },
                child: Text(
                  'Add Video',
                  style: GoogleFonts.aclonica(color: darkColor),
                ))
          ],
        ),
      ));
}
