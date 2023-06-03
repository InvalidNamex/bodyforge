import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '/controllers/coach_controller.dart';
import 'package:intl/intl.dart';

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
      child: Scaffold(
        backgroundColor: Colors.black,
        drawer: Drawer(
          backgroundColor: Colors.black,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                title: Text(
                  'New Client',
                  style: GoogleFonts.aclonica(color: Colors.white),
                ),
                onTap: () => Get.defaultDialog(
                  backgroundColor: Colors.black.withOpacity(0.7),
                  title: 'New Client',
                  titleStyle:
                      GoogleFonts.aclonica(fontSize: 32, color: Colors.red),
                  content: addNewClient(context, controller),
                ),
              ),
              ListTile(
                onTap: () {
                  Get.toNamed('/coach-cpanel');
                },
                leading: const Icon(
                  Icons.admin_panel_settings_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  'Control Panel',
                  style: GoogleFonts.aclonica(color: Colors.white),
                ),
              ),
              ListTile(
                onTap: () {
                  //TODO:log out
                },
                leading: const Icon(
                  Icons.exit_to_app_outlined,
                  color: Colors.red,
                ),
                title: Text(
                  'Log out',
                  style: GoogleFonts.aclonica(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
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
      child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          AppBar(
            backgroundColor: Colors.black.withOpacity(0.8),
            title: Text('Clients',
                style: GoogleFonts.aclonica(color: Colors.white)),
            centerTitle: true,
          ),
          Obx(
            () => controller.traineeList.isEmpty
                ? const Center(
                    child: SpinKitPumpingHeart(
                    color: Colors.red,
                  ))
                : ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Container(
                          color: Colors.black.withOpacity(0.8),
                          child: SizedBox(
                            width: pageWidth,
                            height: 70,
                            child: ListTile(
                              leading: IconButton(
                                icon: const Icon(Icons.copy),
                                color: Colors.white,
                                onPressed: () {
                                  String id = controller
                                      .traineeList[index].traineeID
                                      .toString();
                                  String uri = Uri.base.toString();
                                  String route = uri.replaceAll('/coach-zone',
                                      '/client?client=$id&isCoach=false');
                                  Clipboard.setData(ClipboardData(text: route));
                                  Get.snackbar('Link copied',
                                      'Client link has been copied');
                                },
                              ),
                              title: Text(
                                controller.traineeList[index].traineeName,
                                style:
                                    GoogleFonts.aclonica(color: Colors.white),
                              ),
                              subtitle: Text(
                                controller.traineeList[index].traineeGoal,
                                style: GoogleFonts.lato(
                                    fontSize: 14, color: Colors.red),
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
                                          border: Border.all(color: Colors.red),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Text(
                                        'Diet',
                                        style: GoogleFonts.lato(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                    width: 10,
                                    child: VerticalDivider(
                                      thickness: 2,
                                      color: Colors.black,
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
                                          border: Border.all(color: Colors.red),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Text(
                                        'Workout',
                                        style: GoogleFonts.lato(
                                            fontSize: 14, color: Colors.white),
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
    );

Widget addNewClient(context, controller) {
  return Form(
    key: controller.newClientFormKey,
    child: Column(
      children: [
        TextFormField(
          style: const TextStyle(color: Colors.white),
          controller: controller.clientName,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            labelText: 'client name',
            labelStyle: TextStyle(color: Colors.white),
            prefixIcon: Icon(
              Icons.person,
              color: Colors.red,
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
          style: const TextStyle(color: Colors.white),
          controller: controller.clientGoal,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            labelText: 'client goal',
            labelStyle: TextStyle(color: Colors.white),
            prefixIcon: Icon(
              Icons.accessibility,
              color: Colors.red,
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
            const Text(
              'Join date:',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
              onPressed: () => controller.selectDate(context),
              child: Obx(
                () => Text(
                    DateFormat('dd-MM-yyyy').format(controller.joinDate.value)),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
          onPressed: () async {
            if (controller.newClientFormKey.currentState!.validate()) {
              // Submit form data
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
          child: const Text('Add'),
        ),
      ],
    ),
  );
}
