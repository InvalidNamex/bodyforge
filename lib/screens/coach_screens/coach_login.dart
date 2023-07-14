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
    return MyScaffold(buildContent: buildContent(controller));
  }
}

Widget buildContent(CoachController controller) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Form(
        key: controller.coachLogin,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'images/icon.png',
              height: 40,
              width: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                'Coach Login',
                style: GoogleFonts.aclonica(color: lightColor, fontSize: 24),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              style: TextStyle(color: lightColor),
              autofocus: true,
              controller: controller.coachUserName,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: accentColor),
                ),
                hintText: 'Enter user name',
                hintStyle: TextStyle(color: lightColor),
                labelText: 'Coach Name',
                labelStyle: TextStyle(color: lightColor),
                prefixIcon: Icon(
                  Icons.person,
                  color: accentColor,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              style: TextStyle(color: lightColor),
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
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(accentColor),
              ),
              onPressed: () async {
                //TODO: sign in
                if (controller.coachLogin.currentState!.validate()) {
                  await coachAuthController.loginCoach(
                      controller.coachUserName.text,
                      controller.coachPassword.text);
                }
              },
              child: Text(
                'LOG IN',
                style: TextStyle(color: darkColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
