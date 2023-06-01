import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifit/widgets/transformation_tile.dart';
import 'package:neon/neon.dart';
import '../../controllers/coach_controller.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../widgets/plan_tile.dart';
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
    return Scaffold(
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
        ));
  }
}

Widget buildContent(context, CoachController controller) => Container(
    padding: const EdgeInsets.all(5),
    alignment: Alignment.center,
    constraints: BoxConstraints(maxWidth: pageWidth),
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('images/home-bg.png'),
        fit: BoxFit.fill,
      ),
    ),
    child: ListView(
      children: [
        const SizedBox(
          height: 30,
        ),
        Center(
          child: Neon(
            text: "COACH",
            font: NeonFont.Membra,
            color: Colors.red,
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
                            color: Colors.red, fontSize: 24),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        controller.coach!.coachQuote ?? '',
                        style: GoogleFonts.aclonica(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 20,
                        child: Divider(
                          height: 2,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                )
              ]),
        ),
        const SizedBox(
          height: 20,
          child: Divider(
            height: 2,
            color: Colors.red,
          ),
        ),
        Text(
          'Transformations',
          style: GoogleFonts.aclonica(color: Colors.red, fontSize: 32),
        ),
        const SizedBox(
          height: 10,
        ),
        Obx(() => controller.transList.isEmpty
            ? const SpinKitPumpingHeart(
                color: Colors.red,
              )
            : TransformationTile(controller: controller)),
        const SizedBox(
          height: 20,
          child: Divider(
            height: 2,
            color: Colors.red,
          ),
        ),
        Text(
          'Plans & Offers',
          style: GoogleFonts.aclonica(color: Colors.red, fontSize: 32),
        ),
        const SizedBox(
          height: 10,
        ),
        Obx(() => controller.pricingList.isEmpty
            ? const SpinKitPumpingHeart(
                color: Colors.red,
              )
            : plansWidget(
                context: context,
                controller: controller,
              ))
      ],
    ));
