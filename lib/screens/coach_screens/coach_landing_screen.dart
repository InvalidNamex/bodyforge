import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '/widgets/scaffold_widget.dart';
import '../../helpers/loader_helper.dart';
import '/widgets/transformation_tile.dart';
import 'package:neon/neon.dart';
import '../../controllers/coach_controller.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../widgets/plans_widgets.dart';

class CoachLandingScreen extends GetView<CoachController> {
  const CoachLandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.isLoading(true);
    String? id = Get.parameters['id'];
    controller.getCoachByID(int.parse(id!));
    controller.getTransformations(int.parse(id));
    controller.getPricePlans(int.parse(id));
    return MyScaffold(buildContent: buildContent(context, controller));
  }
}

Widget buildContent(context, CoachController controller) =>
    Obx(() => controller.isLoading.value
        ? Center(
            child: SpinKitPumpingHeart(
              color: accentColor,
            ),
          )
        : ListView(
            children: [
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Neon(
                  text: "COACH",
                  font: NeonFont.Membra,
                  color: Colors.yellow,
                  fontSize: 28,
                ),
              ),
              FittedBox(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(
                        controller.coach!.coachImage,
                        height: 200,
                        width: 200,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Text(
                              controller.coach!.coachName,
                              style: GoogleFonts.aclonica(
                                  color: accentColor, fontSize: 24),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              controller.coach!.coachQuote ?? '',
                              style: GoogleFonts.aclonica(color: lightColor),
                            ),
                          ],
                        ),
                      )
                    ]),
              ),
              SizedBox(
                height: 20,
                child: Divider(
                  height: 2,
                  color: accentColor,
                ),
              ),
              Text(
                'Transformations',
                style: GoogleFonts.aclonica(color: accentColor, fontSize: 32),
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() => controller.transList.isEmpty
                  ? loader()
                  : TransformationTile(controller: controller)),
              SizedBox(
                height: 20,
                child: Divider(
                  height: 2,
                  color: accentColor,
                ),
              ),
              Text(
                'Plans & Offers',
                style: GoogleFonts.aclonica(color: accentColor, fontSize: 32),
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() => controller.pricingList.isEmpty
                  ? loader()
                  : plansWidget(
                      context: context,
                      controller: controller,
                    ))
            ],
          ));
