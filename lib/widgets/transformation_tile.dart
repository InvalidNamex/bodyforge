import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controllers/coach_controller.dart';
import '/widgets/transformation_widget.dart';

class TransformationTile extends GetView {
  @override
  final CoachController controller;
  const TransformationTile({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final transList = controller.transList;
        final screenWidth = MediaQuery.of(context).size.width;
        return SizedBox(
          height: 200,
          width: screenWidth,
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: TransformationWidget(
                  before: transList[index].before!,
                  after: transList[index].after!,
                ),
              );
            },
            itemCount: transList.length,
            scrollDirection: Axis.horizontal,
          ),
        );
      },
    );
  }
}
