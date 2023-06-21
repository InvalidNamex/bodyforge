import 'package:flutter/material.dart';
import '/widgets/scaffold_widget.dart';
import '../../helpers/loader_helper.dart';
import '/controllers/coach_controller.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../widgets/coach_tile.dart';

class CoachesScreen extends GetView<CoachController> {
  const CoachesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getCoaches();
    return MyScaffold(buildContent: buildContent(context, controller));
  }
}

Widget buildContent(context, CoachController controller) =>
    Obx(() => controller.coachesList.isEmpty
        ? Center(child: loader())
        : CoachTile(
            controller: controller,
          ));
