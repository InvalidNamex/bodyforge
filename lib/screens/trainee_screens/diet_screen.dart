import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../models/diet_model.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({Key? key}) : super(key: key);

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
              : Get.toNamed('/diet?client=$_id&isCoach=false');
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
                          'Share Diet',
                          style: GoogleFonts.aclonica(color: Colors.white),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                        title: Text(
                          'Delete All Diet',
                          style: GoogleFonts.aclonica(color: Colors.white),
                        ),
                        onTap: () {
                          Get.defaultDialog(
                              backgroundColor: Colors.black,
                              title: 'Delete Diet',
                              titleStyle:
                                  GoogleFonts.aclonica(color: Colors.white),
                              middleText:
                                  'all diet plan for the client will be deleted!',
                              middleTextStyle:
                                  GoogleFonts.aclonica(color: Colors.white),
                              onCancel: () => Get.back(),
                              buttonColor: Colors.red,
                              confirmTextColor: Colors.white,
                              cancelTextColor: Colors.red,
                              onConfirm: () async {
                                await dietController.deleteDiet();
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
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                                          await addMeal(day: day + 1);
                                        },
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ))
                                    : null,
                                title: Text(
                                  'Day ${day + 1}',
                                  style:
                                      GoogleFonts.aclonica(color: Colors.white),
                                ),
                                subtitle: Text('Day ${day + 1} meals'),
                                children: <Widget>[
                                  Obx(
                                    () => ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: dietController.mealsList
                                            .where(
                                                (item) => item.day == day + 1)
                                            .toList()
                                            .length,
                                        itemBuilder:
                                            (context, index) => ListTile(
                                                  isThreeLine: true,
                                                  leading:
                                                      traineeController.isCoach
                                                          ? IconButton(
                                                              icon: const Icon(
                                                                Icons.edit,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                DietModel _x = dietController
                                                                    .mealsList
                                                                    .where((item) =>
                                                                        item.day ==
                                                                        day + 1)
                                                                    .toList()[index];
                                                                Get
                                                                    .defaultDialog(
                                                                        backgroundColor: Colors
                                                                            .black
                                                                            .withOpacity(
                                                                                0.9),
                                                                        title:
                                                                            'Edit meal',
                                                                        titleStyle: GoogleFonts.aclonica(
                                                                            color: Colors
                                                                                .white),
                                                                        content:
                                                                            Form(
                                                                          key: dietController
                                                                              .editMealKey,
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              TextFormField(
                                                                                style: const TextStyle(color: Colors.white),
                                                                                controller: dietController.mealTitle,
                                                                                decoration: const InputDecoration(
                                                                                  border: OutlineInputBorder(
                                                                                    borderSide: BorderSide(color: Colors.blue),
                                                                                  ),
                                                                                  labelText: 'meal title',
                                                                                  labelStyle: TextStyle(color: Colors.white),
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
                                                                                style: const TextStyle(color: Colors.white),
                                                                                controller: dietController.mealDesc,
                                                                                decoration: const InputDecoration(
                                                                                  border: OutlineInputBorder(
                                                                                    borderSide: BorderSide(color: Colors.blue),
                                                                                  ),
                                                                                  labelText: 'meal description',
                                                                                  labelStyle: TextStyle(color: Colors.white),
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
                                                                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                                                                                  onPressed: () async {
                                                                                    final mealTitle = dietController.mealTitle.text;
                                                                                    final mealDesc = dietController.mealDesc.text;
                                                                                    await dietController.updateMeal(id: _x.dietID!, day: _x.day, mealOrder: _x.mealOrder, title: mealTitle, desc: mealDesc);
                                                                                    dietController.mealTitle.clear();
                                                                                    dietController.mealDesc.clear();
                                                                                    await dietController.populateMealsList();
                                                                                    Get.back();
                                                                                  },
                                                                                  child: Text(
                                                                                    'Edit Meal',
                                                                                    style: GoogleFonts.aclonica(color: Colors.white),
                                                                                  ))
                                                                            ],
                                                                          ),
                                                                        ));
                                                              },
                                                            )
                                                          : null,
                                                  trailing: traineeController
                                                          .isCoach
                                                      ? IconButton(
                                                          icon: const Icon(
                                                            Icons
                                                                .delete_outline,
                                                            color: Colors.red,
                                                          ),
                                                          onPressed: () async {
                                                            int _id = dietController
                                                                .mealsList
                                                                .where((item) =>
                                                                    item.day ==
                                                                    day + 1)
                                                                .toList()[index]
                                                                .dietID!;
                                                            await dietController
                                                                .deleteMeal(
                                                                    _id);
                                                          },
                                                        )
                                                      : null,
                                                  title: Text(
                                                    '${dietController.mealsList.where((item) => item.day == day + 1).toList()[index].title} ',
                                                    style: const TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  subtitle: Text(
                                                    '${dietController.mealsList.where((item) => item.day == day + 1).toList()[index].desc} ',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w800),
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

Future addMeal({required day}) async {
  Get.defaultDialog(
      title: 'Add Meal',
      titleStyle: GoogleFonts.lato(color: Colors.white),
      backgroundColor: Colors.black.withOpacity(0.9),
      content: Form(
        key: dietController.addMealKey,
        child: Column(
          children: [
            TextFormField(
              style: const TextStyle(color: Colors.white),
              controller: dietController.mealTitle,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                labelText: 'meal title',
                labelStyle: TextStyle(color: Colors.white),
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
              style: const TextStyle(color: Colors.white),
              controller: dietController.mealDesc,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                labelText: 'meal description',
                labelStyle: TextStyle(color: Colors.white),
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
                        MaterialStateProperty.all<Color>(Colors.red)),
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
                  style: GoogleFonts.aclonica(color: Colors.white),
                ))
          ],
        ),
      ));
}
