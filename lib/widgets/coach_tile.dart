import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifit/constants.dart';
import '/controllers/coach_controller.dart';

class CoachTile extends GetView {
  @override
  final CoachController controller;
  const CoachTile({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final coachList = controller.coachesList;
        final screenWidth = MediaQuery.of(context).size.width;
        final crossAxisCount = screenWidth < pageWidth ? 2 : 3;
        return GridView.builder(
          itemCount: coachList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed('/coach',
                      parameters: {'id': coachList[index].coachID.toString()});
                },
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                              coachList[index].coachImage,
                            ),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      coachList[index].coachName,
                      style:
                          GoogleFonts.aclonica(color: Colors.red, fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
