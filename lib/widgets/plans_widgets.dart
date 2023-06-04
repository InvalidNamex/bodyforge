import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifit/constants.dart';
import '/widgets/plan_tile.dart';
import '/controllers/coach_controller.dart';

Widget plansWidget(
    {required CoachController controller, required BuildContext context}) {
  return Obx(
    () {
      final pricingList = controller.pricingList;
      final screenWidth = MediaQuery.of(context).size.width;
      final crossAxisCount = screenWidth < pageWidth ? 1 : 2;
      return GridView.builder(
        padding: const EdgeInsets.all(10),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: pricingList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.4),
        itemBuilder: (context, index) {
          return PlanTile(
            plan: pricingList[index],
            coachName: controller.coach!.coachName,
          );
        },
      );
    },
  );
}
