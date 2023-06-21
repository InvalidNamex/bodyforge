import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../models/coach_model.dart';

class FeaturedCoachWidget extends StatelessWidget {
  final RxList<CoachModel> coaches;
  const FeaturedCoachWidget({super.key, required this.coaches});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Obx(
          () => coaches.isEmpty
              ? SpinKitPumpingHeart(
                  color: accentColor,
                )
              : CarouselSlider.builder(
                  options: CarouselOptions(
                    autoPlayInterval: const Duration(seconds: 3),
                    reverse: true,
                    height: 250,
                    viewportFraction: screenWidth < pageWidth ? 1 / 2 : 1 / 4,
                    autoPlay: true,
                  ),
                  itemCount: coaches.length,
                  itemBuilder:
                      (BuildContext context, int index, int realIndex) =>
                          _buildCoachContainer(index),
                ),
        ),
      ],
    );
  }

  Widget _buildCoachContainer(int index) {
    return GestureDetector(
      onTap: () {
        int id = coaches[index].coachID;
        Get.toNamed('/coach', parameters: {'id': id.toString()});
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            height: 200,
            width: 150,
            decoration: BoxDecoration(
              border: Border.all(color: accentColor),
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(coaches[index].coachImage),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            coaches[index].coachName,
            style: GoogleFonts.aclonica(fontSize: 18, color: accentColor),
          ),
        ],
      ),
    );
  }
}
