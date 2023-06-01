import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '/controllers/coach_controller.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../widgets/coach_tile.dart';

class CoachesScreen extends GetView<CoachController> {
  const CoachesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getCoaches();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
        () => controller.coachesList.isEmpty
            ? const Center(
                child: SpinKitPumpingHeart(
                color: Colors.red,
              ))
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
      ),
    );
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
    child: CoachTile(
      controller: controller,
    ));
