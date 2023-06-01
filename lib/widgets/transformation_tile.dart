import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';
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
        return CarouselSlider.builder(
          options: CarouselOptions(
            autoPlayInterval: const Duration(seconds: 3),
            enlargeCenterPage: true,
            scrollPhysics: const NeverScrollableScrollPhysics(),
            viewportFraction: screenWidth < pageWidth ? 1 / 2 : 1 / 3,
            reverse: true,
            autoPlay: true,
          ),
          itemCount: transList.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: TransformationWidget(
                before: transList[index].before,
                after: transList[index].after,
              ),
            );
          },
        );
      },
    );
  }
}
