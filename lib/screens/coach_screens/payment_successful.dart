import 'package:flutter/material.dart';
import '../../widgets/scaffold_widget.dart';
import '/controllers/coach_authentication_controller.dart';
import 'package:get/get.dart';

class PaymentSuccessful extends GetView<CoachAuthController> {
  const PaymentSuccessful({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(buildContent: buildContent(controller));
  }
}

Widget buildContent(CoachAuthController controller) => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [],
    ));
