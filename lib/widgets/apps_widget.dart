import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../constants.dart';
import '../models/app_model.dart';

class AppWidget extends StatelessWidget {
  final RxList<AppModel> apps;
  const AppWidget({super.key, required this.apps});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Obx(
      () => apps.isEmpty
          ? const SpinKitPumpingHeart(
              color: Colors.red,
            )
          : CarouselSlider.builder(
              options: CarouselOptions(
                height: 250,
                autoPlayInterval: const Duration(seconds: 1),
                viewportFraction: screenWidth < pageWidth ? 1 / 2 : 1 / 4,
                reverse: true,
                autoPlay: true,
              ),
              itemCount: apps.length,
              itemBuilder: (BuildContext context, int index, int realIndex) =>
                  _buildCoachContainer(index),
            ),
    );
  }

  Widget _buildCoachContainer(int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
              image: DecorationImage(
                image: NetworkImage(apps[index].appImage),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            apps[index].appName,
            style: GoogleFonts.aclonica(fontSize: 16, color: Colors.white),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 30,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    String url = apps[index].iosUrl;
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url);
                    } else {
                      Get.defaultDialog(
                        title: 'Sorry',
                        content: const Text('App is no longer available'),
                      );
                    }
                  },
                  child: Image.asset(
                    'images/app-store.png',
                    fit: BoxFit.fill,
                    height: 30,
                    width: 30,
                  ),
                ),
                const SizedBox(
                  height: 30,
                  child: VerticalDivider(
                    thickness: 2,
                    width: 10,
                    color: Colors.red,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    String url = apps[index].androidUrl;
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url);
                    } else {
                      Get.defaultDialog(
                        title: 'Sorry',
                        content: const Text('App is no longer available'),
                      );
                    }
                  },
                  child: Image.asset(
                    'images/google-play.png',
                    fit: BoxFit.fill,
                    height: 30,
                    width: 30,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
