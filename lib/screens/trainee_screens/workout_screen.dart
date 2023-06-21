import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../helpers/loader_helper.dart';
import '../../models/custom_workout_model.dart';
import '../../widgets/scaffold_widget.dart';
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
    return MyScaffold(
        drawer: traineeController.isCoach ? drawer() : null,
        buildContent: buildContent(context));
  }
}

Drawer drawer() => Drawer(
      backgroundColor: darkColor.withOpacity(0.9),
      child: ListView(
        children: [
          ListTile(
            onTap: () {
              Get.defaultDialog(
                  backgroundColor: darkColor.withOpacity(0.8),
                  title: traineeController.trainee!.traineeName,
                  titleStyle: GoogleFonts.lato(color: lightColor),
                  content: Column(
                    children: [
                      Text(
                        traineeController.trainee!.traineeGoal,
                        style: GoogleFonts.lato(color: lightColor),
                      ),
                      Text(
                        traineeController.trainee!.traineeJoinDate,
                        style: GoogleFonts.lato(color: lightColor),
                      )
                    ],
                  ));
            },
            leading: Icon(
              Icons.person,
              color: lightColor,
            ),
            title: Text(
              'Client Info',
              style: GoogleFonts.aclonica(color: lightColor),
            ),
          ),
          ListTile(
            onTap: () {
              String id = traineeController.trainee!.traineeID.toString();
              String uri = Uri.base.toString();
              String route = uri.replaceAll(
                  '/coach-zone', '/client?client=$id&isCoach=false');
              Clipboard.setData(ClipboardData(text: route));
              Get.snackbar('Link copied', 'Client link has been copied');
            },
            leading: Icon(
              Icons.share_outlined,
              color: lightColor,
            ),
            title: Text(
              'Share Workout',
              style: GoogleFonts.aclonica(color: lightColor),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.delete_forever,
              color: accentColor,
            ),
            title: Text(
              'Delete Workout Plan',
              style: GoogleFonts.aclonica(color: lightColor),
            ),
            onTap: () {
              Get.defaultDialog(
                  backgroundColor: darkColor,
                  title: 'Delete Workout Plan',
                  titleStyle: GoogleFonts.aclonica(color: lightColor),
                  middleText:
                      'all Workout plan for the client will be deleted!',
                  middleTextStyle: GoogleFonts.aclonica(color: lightColor),
                  onCancel: () => Get.back(),
                  buttonColor: accentColor,
                  confirmTextColor: lightColor,
                  cancelTextColor: accentColor,
                  onConfirm: () async {
                    await workoutController.deleteWorkoutPlan();
                    Get.back();
                  });
            },
          )
        ],
      ),
    );
Widget buildContent(context) => Obx(
      () => !traineeController.traineeLoaded.value
          ? Center(
              child: loader(),
            )
          : Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              AppBar(
                backgroundColor: darkColor.withOpacity(0.7),
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
                            border: Border.all(color: accentColor),
                            color: darkColor.withOpacity(0.9)),
                        child: ExpansionTile(
                          iconColor: accentColor,
                          collapsedIconColor: lightColor,
                          collapsedTextColor: lightColor,
                          leading: traineeController.isCoach
                              ? IconButton(
                                  onPressed: () async {
                                    await addWorkout(day: day + 1);
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: lightColor,
                                  ))
                              : null,
                          title: Text(
                            'Day ${day + 1}',
                            style: GoogleFonts.aclonica(color: lightColor),
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
                                              .where(
                                                  (item) => item.day == day + 1)
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
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: lightColor,
                                                ),
                                                onPressed: () =>
                                                    editExercise(day, index))
                                            : null,
                                        trailing: traineeController.isCoach
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.delete_outline,
                                                  color: accentColor,
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
                                          style: TextStyle(color: accentColor),
                                        ),
                                        subtitle: Text(
                                          '${workoutController.workoutsList.where((item) => item.day == day + 1).toList()[index].desc} ',
                                          style: TextStyle(
                                              color: lightColor,
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
      backgroundColor: darkColor.withOpacity(0.9),
      title: 'Edit workout',
      titleStyle: GoogleFonts.aclonica(color: lightColor),
      content: Form(
        key: workoutController.editWorkoutKey,
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
                    labelStyle: TextStyle(
                        color: lightColor, fontWeight: FontWeight.bold),
                    hintText: "Choose a muscle to train",
                    hintStyle: TextStyle(
                        color: lightColor, fontWeight: FontWeight.bold),
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
                    color: lightColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(50)),
                child: DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSelectedItems: true,
                    disabledItemFn: (String s) => s.startsWith('X'),
                  ),
                  items: workoutController.exercisesList
                      .map((ExerciseModel model) => model.exercise)
                      .toList(),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    baseStyle: TextStyle(color: accentColor),
                    dropdownSearchDecoration: const InputDecoration(
                      labelText: "Exercise",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      hintText: "Choose an exercise",
                      hintStyle: TextStyle(fontWeight: FontWeight.bold),
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
              style: TextStyle(color: lightColor),
              controller: workoutController.workoutDesc,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: accentColor),
                    borderRadius: BorderRadius.circular(50)),
                labelText: 'workout description',
                labelStyle: TextStyle(color: lightColor),
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
                        MaterialStateProperty.all<Color>(accentColor)),
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
                  style: GoogleFonts.aclonica(color: darkColor),
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
      titleStyle: GoogleFonts.lato(color: lightColor),
      backgroundColor: darkColor.withOpacity(0.9),
      content: Form(
        key: workoutController.addWorkoutKey,
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
                    color: lightColor.withOpacity(0.7),
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
                    baseStyle: TextStyle(fontWeight: FontWeight.bold),
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Exercise",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      hintText: "Choose an exercise",
                      hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  selectedItem: 'Bench press',
                  onChanged: (String? muscle) {
                    workoutController.workoutTitle.text =
                        muscle ?? 'Bench press';

                    ExerciseModel? selectedExercise =
                        workoutController.exercisesList.firstWhereOrNull((e) =>
                            e.exercise == workoutController.workoutTitle.text);

                    if (selectedExercise != null) {
                      CustomWorkoutModel? customWorkout = workoutController
                          .custExercisesList
                          .firstWhereOrNull((c) =>
                              c.exerciseID == selectedExercise.exerciseID);

                      if (customWorkout != null) {
                        workoutController.workoutUrl.text = customWorkout.url;
                      } else {
                        workoutController.workoutUrl.text =
                            selectedExercise.url;
                      }
                    }
                  },
                ),
              ),
            ),
            TextFormField(
              style: TextStyle(color: lightColor),
              controller: workoutController.workoutDesc,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                labelText: 'workout description',
                labelStyle: TextStyle(color: lightColor),
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
                        MaterialStateProperty.all<Color>(accentColor)),
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
                  style: GoogleFonts.aclonica(color: darkColor),
                ))
          ],
        ),
      ));
}
