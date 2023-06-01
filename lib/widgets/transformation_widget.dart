import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_compare_slider/image_compare_slider.dart';

import '../controllers/coach_controller.dart';

class TransformationWidget extends GetView<CoachController> {
  const TransformationWidget(
      {super.key, required this.before, required this.after});
  final String before;
  final String after;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: 200,
      width: 150,
      child: FittedBox(
        fit: BoxFit.fill,
        child: ImageCompareSlider(
          dividerColor: Colors.red,
          changePositionOnHover: true,
          dividerWidth: 2,
          handleSize: const Size(10, 10),
          handleRadius: BorderRadius.circular(50),
          fillHandle: true,
          itemOne: Image.network(
            before,
            fit: BoxFit.fill,
          ),
          itemTwo: Image.network(
            after,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
