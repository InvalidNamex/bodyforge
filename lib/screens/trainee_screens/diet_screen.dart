import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '/widgets/scaffold_widget.dart';
import '../../constants.dart';
import '../../helpers/loader_helper.dart';
import '../../models/diet_model.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({Key? key}) : super(key: key);

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
                                    await addMeal(day: day + 1);
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
                          subtitle: Text('Day ${day + 1} meals'),
                          children: <Widget>[
                            Obx(
                              () => ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: dietController.mealsList
                                      .where((item) => item.day == day + 1)
                                      .toList()
                                      .length,
                                  itemBuilder: (context, index) => ListTile(
                                        isThreeLine: true,
                                        leading: traineeController.isCoach
                                            ? IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () async {
                                                  DietModel _x = dietController
                                                      .mealsList
                                                      .where((item) =>
                                                          item.day == day + 1)
                                                      .toList()[index];
                                                  Get.defaultDialog(
                                                      backgroundColor: Colors
                                                          .black
                                                          .withOpacity(0.9),
                                                      title: 'Edit meal',
                                                      titleStyle:
                                                          GoogleFonts.aclonica(
                                                              color:
                                                                  Colors.white),
                                                      content: Form(
                                                        key: dietController
                                                            .editMealKey,
                                                        child: Column(
                                                          children: [
                                                            TextFormField(
                                                              style: TextStyle(
                                                                  color:
                                                                      lightColor),
                                                              controller:
                                                                  dietController
                                                                      .mealTitle,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    const OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.blue),
                                                                ),
                                                                labelText:
                                                                    'meal title',
                                                                labelStyle:
                                                                    TextStyle(
                                                                        color:
                                                                            lightColor),
                                                                hintText:
                                                                    'enter meal title (Breakfast)',
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter meal title';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                            TextFormField(
                                                              maxLines: 6,
                                                              style: TextStyle(
                                                                  color:
                                                                      lightColor),
                                                              controller:
                                                                  dietController
                                                                      .mealDesc,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    const OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.blue),
                                                                ),
                                                                labelText:
                                                                    'meal description',
                                                                labelStyle:
                                                                    TextStyle(
                                                                        color:
                                                                            lightColor),
                                                                hintText:
                                                                    'enter meal description (2 eggs 1 yolk)',
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter meal description';
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
                                                                        MaterialStateProperty.all<Color>(
                                                                            accentColor)),
                                                                onPressed:
                                                                    () async {
                                                                  final mealTitle =
                                                                      dietController
                                                                          .mealTitle
                                                                          .text;
                                                                  final mealDesc =
                                                                      dietController
                                                                          .mealDesc
                                                                          .text;
                                                                  await dietController.updateMeal(
                                                                      id: _x
                                                                          .dietID!,
                                                                      day: _x
                                                                          .day,
                                                                      mealOrder: _x
                                                                          .mealOrder,
                                                                      title:
                                                                          mealTitle,
                                                                      desc:
                                                                          mealDesc);
                                                                  dietController
                                                                      .mealTitle
                                                                      .clear();
                                                                  dietController
                                                                      .mealDesc
                                                                      .clear();
                                                                  await dietController
                                                                      .populateMealsList();
                                                                  Get.back();
                                                                },
                                                                child: Text(
                                                                  'Edit Meal',
                                                                  style: GoogleFonts
                                                                      .aclonica(
                                                                          color:
                                                                              darkColor),
                                                                ))
                                                          ],
                                                        ),
                                                      ));
                                                },
                                              )
                                            : null,
                                        trailing: traineeController.isCoach
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.delete_outline,
                                                  color: accentColor,
                                                ),
                                                onPressed: () async {
                                                  int _id = dietController
                                                      .mealsList
                                                      .where((item) =>
                                                          item.day == day + 1)
                                                      .toList()[index]
                                                      .dietID!;
                                                  await dietController
                                                      .deleteMeal(_id);
                                                },
                                              )
                                            : null,
                                        title: Text(
                                          '${dietController.mealsList.where((item) => item.day == day + 1).toList()[index].title} ',
                                          style: TextStyle(color: accentColor),
                                        ),
                                        subtitle: Text(
                                          '${dietController.mealsList.where((item) => item.day == day + 1).toList()[index].desc} ',
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
              'Share Diet',
              style: GoogleFonts.aclonica(color: lightColor),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.delete_forever,
              color: accentColor,
            ),
            title: Text(
              'Delete All Diet',
              style: GoogleFonts.aclonica(color: lightColor),
            ),
            onTap: () {
              Get.defaultDialog(
                  backgroundColor: darkColor,
                  title: 'Delete Diet',
                  titleStyle: GoogleFonts.aclonica(color: lightColor),
                  middleText: 'all diet plan for the client will be deleted!',
                  middleTextStyle: GoogleFonts.aclonica(color: lightColor),
                  onCancel: () => Get.back(),
                  buttonColor: accentColor,
                  confirmTextColor: lightColor,
                  cancelTextColor: accentColor,
                  onConfirm: () async {
                    await dietController.deleteDiet();
                    Get.back();
                  });
            },
          )
        ],
      ),
    );

Future addMeal({required day}) async {
  Get.defaultDialog(
      title: 'Add Meal',
      titleStyle: GoogleFonts.lato(color: lightColor),
      backgroundColor: darkColor.withOpacity(0.9),
      content: Form(
        key: dietController.addMealKey,
        child: Column(
          children: [
            TextFormField(
              style: TextStyle(color: lightColor),
              controller: dietController.mealTitle,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: accentColor),
                ),
                labelText: 'meal title',
                labelStyle: TextStyle(color: lightColor),
                hintText: 'enter meal title (Breakfast)',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter meal title';
                }
                return null;
              },
            ),
            TextFormField(
              maxLines: 6,
              style: TextStyle(color: lightColor),
              controller: dietController.mealDesc,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: accentColor),
                ),
                labelText: 'meal description',
                labelStyle: TextStyle(color: lightColor),
                hintText: 'enter meal description (2 eggs 1 yolk)',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter meal description';
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
                  int order = dietController.mealsList
                          .where((item) => item.day == day)
                          .toList()
                          .length +
                      1;
                  final mealTitle = dietController.mealTitle.text;
                  final mealDesc = dietController.mealDesc.text;
                  await dietController.addMeal(
                    day: day,
                    title: mealTitle,
                    desc: mealDesc,
                    trainee: traineeController.trainee!.traineeID!,
                    order: order,
                  );
                  dietController.mealTitle.clear();
                  dietController.mealDesc.clear();
                  await dietController.populateMealsList();
                  Get.back();
                },
                child: Text(
                  'Add meal',
                  style: GoogleFonts.aclonica(color: darkColor),
                ))
          ],
        ),
      ));
}
