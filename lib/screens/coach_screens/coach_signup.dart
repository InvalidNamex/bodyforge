import '/constants.dart';
import '/controllers/coach_authentication_controller.dart';
import 'package:neon/neon.dart';

import '../../widgets/scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoachSignUp extends GetView<CoachAuthController> {
  const CoachSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      buildContent: buildContent(context, controller),
    );
  }
}

Widget buildContent(context, CoachAuthController controller) => Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: lightColor.withOpacity(0.1),
          child: Form(
            key: controller.coachSignupForm,
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Neon(
                    text: 'SIGN UP',
                    font: NeonFont.TextMeOne,
                    color: Colors.yellow,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: lightColor),
                    controller: controller.coachEmail,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: accentColor),
                      ),
                      labelText: 'e-mail',
                      labelStyle: TextStyle(color: lightColor),
                      prefixIcon: Icon(
                        Icons.mail_outline,
                        color: accentColor,
                      ),
                      hintText: 'Enter email',
                      hintStyle: TextStyle(color: lightColor),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: lightColor),
                    controller: controller.coachName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: accentColor),
                      ),
                      labelText: 'coach name',
                      labelStyle: TextStyle(color: lightColor),
                      prefixIcon: Icon(
                        Icons.person,
                        color: accentColor,
                      ),
                      hintText: 'Enter coach name',
                      hintStyle: TextStyle(color: lightColor),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter client name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    style: TextStyle(color: lightColor),
                    autofocus: true,
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: lightColor),
                    controller: controller.coachPhone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: accentColor),
                      ),
                      labelText: 'phone number',
                      labelStyle: TextStyle(color: lightColor),
                      prefixIcon: Icon(
                        Icons.phone_android,
                        color: accentColor,
                      ),
                      hintText: '+123 456 789',
                      hintStyle: TextStyle(color: lightColor),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please a valid phone number';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(accentColor),
                    ),
                    onPressed: () => signUp(controller),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: darkColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

void signUp(CoachAuthController controller) async {
  if (controller.coachSignupForm.currentState!.validate()) {
    String? id = Get.parameters['id'];
    if (id != null || id != '') {
      try {
        controller.coachSignup(
            coachName: controller.coachName.text,
            coachPassword: controller.coachPassword.text,
            coachEmail: controller.coachEmail.text,
            coachPhone: controller.coachPhone.text,
            planId: id);
        controller.coachName.clear();
        controller.coachPassword.clear();
        controller.coachEmail.clear();
        controller.coachPhone.clear();
      } catch (e) {
        Get.snackbar('error occurred', e.toString());
      }
    }
  }
}
