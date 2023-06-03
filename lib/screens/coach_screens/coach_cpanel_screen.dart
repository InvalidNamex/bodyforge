import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/coach_image_picker.dart';
import '/controllers/coach_controller.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class CoachCPanel extends GetView<CoachController> {
  const CoachCPanel({super.key});

  Widget build(BuildContext context) {
    controller.populateCoach();
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/coach-zone');
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
            backgroundColor: Colors.black.withOpacity(0.8),
            title: Text('Control Panel',
                style: GoogleFonts.aclonica(color: Colors.white)),
            centerTitle: true,
          ),
          ListView(
            shrinkWrap: true,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.red),
                    color: Colors.black.withOpacity(0.9)),
                child: ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Change Picture',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: imagePicker(
                      buttonText: 'Choose Image', bucket: 'coach_image'),
                ),
              )
            ],
          )
        ],
      ),
    );
