import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '/../constants.dart';
import '/../models/workout_model.dart';
import '/../models/exercise_model.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    traineeController.getTrainee();
    String? isCoach = Get.parameters['isCoach'] ?? 'true';
    traineeController.isCoach = isCoach.toLowerCase() != "false";
    return WillPopScope(
        onWillPop: () async {
          int _id = traineeController.trainee!.traineeID!;
          traineeController.isCoach
              ? Get.toNamed('/coach-zone')
              : Get.toNamed('/workout?client=$_id&isCoach=false');
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          endDrawer: traineeController.isCoach
              ? Drawer(
                  backgroundColor: Colors.black.withOpacity(0.9),
                  child: ListView(
                    children: [
                      ListTile(
                        onTap: () {
                          Get.defaultDialog(
                              backgroundColor: Colors.black.withOpacity(0.8),
                              title: traineeController.trainee!.traineeName,
                              titleStyle: GoogleFonts.lato(color: Colors.white),
                              content: Column(
                                children: [
                                  Text(
                                    traineeController.trainee!.traineeGoal,
                                    style:
                                        GoogleFonts.lato(color: Colors.white),
                                  ),
                                  Text(
                                    traineeController.trainee!.traineeJoinDate,
                                    style:
                                        GoogleFonts.lato(color: Colors.white),
                                  )
                                ],
                              ));
                        },
                        leading: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Client Info',
                          style: GoogleFonts.aclonica(color: Colors.white),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          String id =
                              traineeController.trainee!.traineeID.toString();
                          String uri = Uri.base.toString();
                          String route = uri.replaceAll('/coach-zone',
                              '/client?client=$id&isCoach=false');
                          Clipboard.setData(ClipboardData(text: route));
                          Get.snackbar(
                              'Link copied', 'Client link has been copied');
                        },
                        leading: const Icon(
                          Icons.share_outlined,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Share Workout',
                          style: GoogleFonts.aclonica(color: Colors.white),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                        title: Text(
                          'Delete Workout Plan',
                          style: GoogleFonts.aclonica(color: Colors.white),
                        ),
                        onTap: () {
                          Get.defaultDialog(
                              backgroundColor: Colors.black,
                              title: 'Delete Workout Plan',
                              titleStyle:
                                  GoogleFonts.aclonica(color: Colors.white),
                              middleText:
                                  'all Workout plan for the client will be deleted!',
                              middleTextStyle:
                                  GoogleFonts.aclonica(color: Colors.white),
                              onCancel: () => Get.back(),
                              buttonColor: Colors.red,
                              confirmTextColor: Colors.white,
                              cancelTextColor: Colors.red,
                              onConfirm: () async {
                                await workoutController.deleteWorkoutPlan();
                                Get.back();
                              });
                        },
                      )
                    ],
                  ),
                )
              : null,
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth > pageWidth) {
                return Center(
                  child: Container(
                    alignment: Alignment.topCenter,
                    width: pageWidth,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: buildContent(context),
                  ),
                );
              } else {
                return buildContent(context);
              }
            },
          ),
        ));
  }
}

Widget buildContent(context) => Obx(
      () => !traineeController.traineeLoaded.value
          ? const Center(
              child: SpinKitPumpingHeart(
                color: Colors.red,
              ),
            )
          : Container(
              alignment: Alignment.topCenter,
              constraints: BoxConstraints(maxWidth: pageWidth),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(coachController.coach!.coachImage),
                  fit: BoxFit.fill,
                ),
              ),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                AppBar(
                  backgroundColor: Colors.black.withOpacity(0.7),
                  title: Text(traineeController.trainee!.traineeName),
                  centerTitle: true,
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 7,
                      itemBuilder: (context, day) {
                        return Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.red),
                              color: Colors.black.withOpacity(0.9)),
                          child: ExpansionTile(
                            iconColor: Colors.red,
                            collapsedIconColor: Colors.white,
                            collapsedTextColor: Colors.white,
                            leading: traineeController.isCoach
                                ? IconButton(
                                    onPressed: () async {
                                      await addWorkout(day: day + 1);
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ))
                                : null,
                            title: Text(
                              'Day ${day + 1}',
                              style: GoogleFonts.aclonica(color: Colors.white),
                            ),
                            subtitle: Text('Day ${day + 1} workout'),
                            children: <Widget>[
                              Obx(
                                () => ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: workoutController.workoutsList
                                        .where((item) => item.day == day + 1)
                                        .toList()
                                        .length,
                                    itemBuilder: (context, index) => ListTile(
                                          onTap: () async {
                                            String url = workoutController
                                                .workoutsList
                                                .where((item) =>
                                                    item.day == day + 1)
                                                .toList()[index]
                                                .url;
                                            if (await canLaunchUrlString(url)) {
                                              await launchUrlString(url);
                                            } else {
                                              Get.defaultDialog(
                                                title: 'Sorry',
                                                content: const Text(
                                                    'Video is no longer available'),
                                              );
                                            }
                                          },
                                          isThreeLine: true,
                                          leading: traineeController.isCoach
                                              ? IconButton(
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () =>
                                                      editExercise(day, index))
                                              : null,
                                          trailing: traineeController.isCoach
                                              ? IconButton(
                                                  icon: const Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () async {
                                                    int _id = workoutController
                                                        .workoutsList
                                                        .where((item) =>
                                                            item.day == day + 1)
                                                        .toList()[index]
                                                        .workoutID!;
                                                    await workoutController
                                                        .deleteExercise(_id);
                                                  },
                                                )
                                              : null,
                                          title: Text(
                                            '${workoutController.workoutsList.where((item) => item.day == day + 1).toList()[index].title} ',
                                            style: const TextStyle(
                                                color: Colors.red),
                                          ),
                                          subtitle: Text(
                                            '${workoutController.workoutsList.where((item) => item.day == day + 1).toList()[index].desc} ',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        )),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ]),
            ),
    );

Future editExercise(day, index) async {
  await workoutController.getExercisesByMuscleGroup('Chest');
  workoutController.workoutTitle.text = 'Bench press';
  workoutController.workoutUrl.text =
      'https://youtube.com/shorts/0cXAp6WhSj4?feature=share';
  WorkoutModel _x = workoutController.workoutsList
      .where((item) => item.day == day + 1)
      .toList()[index];
  Get.defaultDialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      title: 'Edit workout',
      titleStyle: GoogleFonts.aclonica(color: Colors.white),
      content: Form(
        key: workoutController.editWorkoutKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.7),
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
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  baseStyle: TextStyle(color: Colors.white),
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Muscle Group",
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "Choose a muscle to train",
                    hintStyle: TextStyle(color: Colors.white),
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
                    color: Colors.white.withOpacity(0.7),
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
                    baseStyle: TextStyle(color: Colors.red),
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Exercise",
                      labelStyle: TextStyle(color: Colors.red),
                      hintText: "Choose an exercise",
                      hintStyle: TextStyle(color: Colors.red),
                    ),
                  ),
                  onChanged: (String? muscle) {
                    muscle!.isEmpty
                        ? workoutController.workoutTitle.text = muscle
                        : 'Bench press';
                    String url = workoutController.exercisesList
                        .where((e) =>
                            e.exercise == workoutController.workoutTitle.text)
                        .first
                        .url;
                    workoutController.workoutUrl.text = url;
                  },
                  selectedItem: 'Bench press',
                ),
              ),
            ),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              controller: workoutController.workoutDesc,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(50)),
                labelText: 'workout description',
                labelStyle: const TextStyle(color: Colors.white),
                hintText:
                    'enter workout description (bench press 12 reps 4 sets)',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter workout description';
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
                        MaterialStateProperty.all<Color>(Colors.red)),
                onPressed: () async {
                  final workoutTitle = workoutController.workoutTitle.text;
                  final workoutDesc = workoutController.workoutDesc.text;
                  final workoutUrl = workoutController.workoutUrl.text;
                  await workoutController.updateWorkout(
                      id: _x.workoutID!,
                      day: _x.day,
                      exerciseOrder: _x.exerciseOrder,
                      title: workoutTitle,
                      desc: workoutDesc,
                      url: workoutUrl);
                  workoutController.workoutTitle.clear();
                  workoutController.workoutDesc.clear();
                  await workoutController.populateWorkoutsList();
                  Get.back();
                },
                child: Text(
                  'Edit workout',
                  style: GoogleFonts.aclonica(color: Colors.white),
                ))
          ],
        ),
      ));
}

Future addWorkout({required day}) async {
  await workoutController.getExercisesByMuscleGroup('Chest');
  workoutController.workoutTitle.text = 'Bench press';
  Get.defaultDialog(
      title: 'Add Workout',
      titleStyle: GoogleFonts.lato(color: Colors.white),
      backgroundColor: Colors.black.withOpacity(0.9),
      content: Form(
        key: workoutController.addWorkoutKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.7),
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
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  baseStyle: TextStyle(color: Colors.white),
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Muscle Group",
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "Choose a muscle to train",
                    hintStyle: TextStyle(color: Colors.white),
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
                    color: Colors.white.withOpacity(0.7),
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
                    baseStyle: TextStyle(color: Colors.red),
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Exercise",
                      labelStyle: TextStyle(color: Colors.red),
                      hintText: "Choose an exercise",
                      hintStyle: TextStyle(color: Colors.red),
                    ),
                  ),
                  onChanged: (String? muscle) {
                    workoutController.workoutTitle.text =
                        muscle ?? 'Bench press';
                    String url = workoutController.exercisesList
                        .where((e) =>
                            e.exercise == workoutController.workoutTitle.text)
                        .first
                        .url;
                    workoutController.workoutUrl.text = url;
                  },
                  selectedItem: 'Bench press',
                ),
              ),
            ),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              controller: workoutController.workoutDesc,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(50)),
                labelText: 'workout description',
                labelStyle: const TextStyle(color: Colors.white),
                hintText:
                    'enter workout description (military press 10 reps 3 sets)',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter workout description';
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
                        MaterialStateProperty.all<Color>(Colors.red)),
                onPressed: () async {
                  int order = workoutController.workoutsList
                          .where((item) => item.day == day)
                          .toList()
                          .length +
                      1;
                  final workoutTitle = workoutController.workoutTitle.text;
                  final workoutDesc = workoutController.workoutDesc.text;
                  final workoutUrl = workoutController.workoutUrl.text;
                  await workoutController.addWorkout(
                      day: day,
                      title: workoutTitle,
                      desc: workoutDesc,
                      trainee: traineeController.trainee!.traineeID!,
                      order: order,
                      url: workoutUrl);
                  workoutController.workoutTitle.clear();
                  workoutController.workoutDesc.clear();
                  workoutController.workoutUrl.clear();
                  await workoutController.populateWorkoutsList();
                  Get.back();
                },
                child: Text(
                  'Add workout',
                  style: GoogleFonts.aclonica(color: Colors.white),
                ))
          ],
        ),
      ));
}
