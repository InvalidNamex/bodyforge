import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '/widgets/scaffold_widget.dart';
import '/constants.dart';
import '/controllers/coach_controller.dart';
import '../not_found.dart';

class CoachLogin extends GetView<CoachController> {
  const CoachLogin({super.key});

  @override
  Widget build(BuildContext context) {
    controller.checkCoach();
    return MyScaffold(buildContent: buildContent(controller));
  }
}

Widget buildContent(CoachController controller) =>
    Obx(() => controller.isLoading.value
        ? Center(
            child: SpinKitPumpingHeart(
              color: accentColor,
            ),
          )
        : controller.coach == null
            ? const NotFound()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: SizedBox(
                      height: 150.0,
                      width: 150.0,
                      child: Image.network(
                        controller.coach!.coachImage,
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Text(
                        'Coach:',
                        style: GoogleFonts.aclonica(
                            fontSize: 24, color: accentColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    style: TextStyle(color: lightColor),
                    autofocus: true,
                    onEditingComplete: () => controller.validatePassword(),
                    obscureText: true,
                    controller: controller.coachPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: accentColor),
                      ),
                      hintText: 'Enter password',
                      hintStyle: TextStyle(color: lightColor),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: lightColor),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: accentColor,
                      ),
                    ),
                  ),
                ],
              ));
