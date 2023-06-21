import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '/widgets/scaffold_widget.dart';
import '/controllers/coach_controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';

class CoachHome extends GetView<CoachController> {
  const CoachHome({super.key});
  @override
  Widget build(BuildContext context) {
    controller.populateCoach();
    return WillPopScope(
        onWillPop: () async {
          Get.offNamed('/coach-zone');
          return true;
        },
        child: MyScaffold(
          drawer: drawer(context, controller),
          buildContent: buildContent(context, controller),
        ));
  }
}

Drawer drawer(context, controller) => Drawer(
      backgroundColor: darkColor,
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            leading: Icon(
              Icons.add,
              color: lightColor,
            ),
            title: Text(
              'New Client',
              style: GoogleFonts.aclonica(color: lightColor),
            ),
            onTap: () => Get.defaultDialog(
              backgroundColor: darkColor.withOpacity(0.7),
              title: 'New Client',
              titleStyle:
                  GoogleFonts.aclonica(fontSize: 32, color: accentColor),
              content: addNewClient(context, controller),
            ),
          ),
          ListTile(
            onTap: () {
              Get.toNamed('/coach-cpanel');
            },
            leading: Icon(
              Icons.admin_panel_settings_outlined,
              color: lightColor,
            ),
            title: Text(
              'Control Panel',
              style: GoogleFonts.aclonica(color: lightColor),
            ),
          ),
        ],
      ),
    );

Widget buildContent(context, CoachController controller) =>
    Obx(() => controller.isLoading.value
        ? Center(
            child: SpinKitPumpingHeart(
              color: accentColor,
            ),
          )
        : Container(
            alignment: Alignment.topCenter,
            constraints: BoxConstraints(maxWidth: pageWidth),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(controller.coach!.coachImage),
                fit: BoxFit.fill,
              ),
            ),
            child: SingleChildScrollView(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                AppBar(
                  backgroundColor: darkColor.withOpacity(0.8),
                  title: Text('Clients',
                      style: GoogleFonts.aclonica(color: lightColor)),
                  centerTitle: true,
                ),
                Obx(
                  () => controller.traineeList.isEmpty
                      ? Center(
                          child: SpinKitPumpingHeart(
                          color: accentColor,
                        ))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) => Container(
                                color: darkColor.withOpacity(0.8),
                                child: SizedBox(
                                  width: pageWidth,
                                  height: 70,
                                  child: ListTile(
                                    leading: IconButton(
                                      icon: const Icon(Icons.copy),
                                      color: lightColor,
                                      onPressed: () {
                                        String id = controller
                                            .traineeList[index].traineeID
                                            .toString();
                                        String uri = Uri.base.toString();
                                        String route = uri.replaceAll(
                                            '/coach-zone',
                                            '/client?client=$id&isCoach=false');
                                        Clipboard.setData(
                                            ClipboardData(text: route));
                                        Get.snackbar('Link copied',
                                            'Client link has been copied');
                                      },
                                    ),
                                    title: Text(
                                      controller.traineeList[index].traineeName,
                                      style: GoogleFonts.aclonica(
                                          color: lightColor),
                                    ),
                                    subtitle: Text(
                                      controller.traineeList[index].traineeGoal,
                                      style: GoogleFonts.lato(
                                          fontSize: 14, color: accentColor),
                                    ),
                                    trailing: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            int _x = controller
                                                .traineeList[index].traineeID!;
                                            Get.toNamed('/diet?client=$_x');
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: accentColor),
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Text(
                                              'Diet',
                                              style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  color: lightColor),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: 10,
                                          child: VerticalDivider(
                                            thickness: 2,
                                            color: darkColor,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            int _x = controller
                                                .traineeList[index].traineeID!;
                                            Get.toNamed('/workout?client=$_x');
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: accentColor),
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Text(
                                              'Workout',
                                              style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  color: lightColor),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          itemCount: controller.traineeList.length),
                ),
              ]),
            ),
          ));

Widget addNewClient(context, CoachController controller) {
  return Form(
    key: controller.newClientFormKey,
    child: Column(
      children: [
        TextFormField(
          style: TextStyle(color: lightColor),
          controller: controller.clientName,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: accentColor),
            ),
            labelText: 'client name',
            labelStyle: TextStyle(color: lightColor),
            prefixIcon: Icon(
              Icons.person,
              color: accentColor,
            ),
            hintText: 'Enter client name',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter client name';
            }
            return null;
          },
        ),
        TextFormField(
          style: TextStyle(color: lightColor),
          controller: controller.clientGoal,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: accentColor),
            ),
            labelText: 'client goal',
            labelStyle: TextStyle(color: lightColor),
            prefixIcon: Icon(
              Icons.accessibility,
              color: accentColor,
            ),
            hintText: 'Enter client name',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter client name';
            }
            return null;
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Join date:',
              style: TextStyle(color: lightColor),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(accentColor)),
              onPressed: () => controller.selectDate(context),
              child: Obx(
                () => Text(
                  DateFormat('dd-MM-yyyy').format(controller.joinDate.value),
                  style: TextStyle(color: darkColor),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(accentColor)),
          onPressed: () async {
            if (controller.newClientFormKey.currentState!.validate()) {
              final clientName = controller.clientName.text;
              final clientGoal = controller.clientGoal.text;
              final joinDate =
                  DateFormat('dd-MM-yyyy').format(controller.joinDate.value);
              await controller.addTrainee(clientName, clientGoal, joinDate);
              controller.clientName.clear();
              controller.clientGoal.clear();
              controller.joinDate.value = DateTime.now();
              Get.back();
            }
          },
          child: Text(
            'Add',
            style: TextStyle(color: darkColor),
          ),
        ),
      ],
    ),
  );
}
