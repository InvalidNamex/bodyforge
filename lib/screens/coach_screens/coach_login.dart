import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '/constants.dart';
import '/controllers/coach_controller.dart';
import '../not_found.dart';

class CoachLogin extends GetView<CoachController> {
  const CoachLogin({super.key});

  @override
  Widget build(BuildContext context) {
    controller.checkCoach();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: SpinKitPumpingHeart(
                  color: Colors.red,
                ),
              )
            : controller.coach == null
                ? const NotFound()
                : LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      if (constraints.maxWidth > pageWidth) {
                        return Center(
                          child: Container(
                            width: pageWidth,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: buildContent(controller),
                          ),
                        );
                      } else {
                        return buildContent(controller);
                      }
                    },
                  ),
      ),
    );
  }
}

Widget buildContent(CoachController controller) => Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.all(20),
    constraints: BoxConstraints(maxWidth: pageWidth),
    decoration: const BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.fill,
        image: AssetImage('images/home-bg.png'),
      ),
    ),
    child: Column(
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
              style: GoogleFonts.aclonica(fontSize: 24, color: Colors.red),
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        TextFormField(
          style: const TextStyle(color: Colors.white),
          autofocus: true,
          onEditingComplete: () => controller.validatePassword(),
          obscureText: true,
          controller: controller.coachPassword,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            hintText: 'Enter password',
            hintStyle: TextStyle(color: Colors.white),
            labelText: 'Password',
            labelStyle: TextStyle(color: Colors.white),
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.red,
            ),
          ),
        ),
      ],
    ));
