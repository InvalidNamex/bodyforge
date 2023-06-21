import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '/widgets/scaffold_widget.dart';
import 'package:neon/neon.dart';
import '/controllers/trainee_controller.dart';
import 'package:get/get.dart';
import '../../constants.dart';

class ClientScreen extends GetView<TraineeController> {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.initiateClientScreen();
    return WillPopScope(
        onWillPop: () async {
          int _id = controller.trainee!.traineeID!;
          Get.offNamed('/client?client=$_id&isCoach=false');
          return true;
        },
        child: MyScaffold(
          buildContent: buildContent(context, controller),
        ));
  }
}

Widget buildContent(context, TraineeController controller) =>
    Obx(() => !controller.traineeLoaded.value
        ? Center(
            child: SpinKitPumpingHeart(
              color: accentColor,
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      !coachController.isLoading.value
                          ? SizedBox(
                              height: 260.0,
                              width: 200.0,
                              child: Column(
                                children: [
                                  FittedBox(
                                    child: Neon(
                                      text: coachController.coach!.coachName,
                                      font: NeonFont.Membra,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Image.network(
                                    coachController.coach!.coachImage,
                                    height: 200,
                                    width: 200,
                                  ),
                                ],
                              ),
                            )
                          : SpinKitPumpingHeart(
                              color: accentColor,
                            ),
                      controller.trainee == null
                          ? SpinKitPumpingHeart(
                              color: accentColor,
                            )
                          : Column(
                              children: [
                                Text(
                                  controller.trainee!.traineeName,
                                  style: GoogleFonts.aclonica(
                                      color: accentColor, fontSize: 24),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  controller.trainee!.traineeGoal,
                                  style:
                                      GoogleFonts.aclonica(color: lightColor),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  controller.trainee!.traineeJoinDate,
                                  style:
                                      GoogleFonts.aclonica(color: lightColor),
                                ),
                              ],
                            )
                    ]),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        int _x = int.parse(Get.parameters['client']!);
                        Get.toNamed('/diet?client=$_x&isCoach=false');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 35),
                        decoration: BoxDecoration(
                            border: Border.all(color: accentColor),
                            borderRadius: BorderRadius.circular(25)),
                        child: Text(
                          'Diet',
                          style: GoogleFonts.aclonica(
                              fontSize: 22, color: lightColor),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                      height: 40,
                      child: VerticalDivider(
                        color: accentColor,
                        width: 2,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        int _x = int.parse(Get.parameters['client']!);
                        Get.toNamed('/workout?client=$_x&isCoach=false');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: accentColor),
                            borderRadius: BorderRadius.circular(25)),
                        child: Text(
                          'Workout',
                          style: GoogleFonts.aclonica(
                              fontSize: 22, color: lightColor),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ));
