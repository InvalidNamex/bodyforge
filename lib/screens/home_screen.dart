import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '/controllers/home_controller.dart';
import '/widgets/featured_coach_widget.dart';
import 'package:neon/neon.dart';

import '../constants.dart';
import '../widgets/apps_widget.dart';
import '../widgets/books_widget.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => HomeController());
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > pageWidth) {
            return Center(
              child: Container(
                width: pageWidth,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: buildContent(context, controller),
              ),
            );
          } else {
            return buildContent(context, controller);
          }
        },
      ),
    );
  }
}

Widget buildContent(context, HomeController controller) =>
    Obx(() => controller.coachList.isEmpty
        ? const Center(
            child: SpinKitPumpingHeart(
              color: Colors.red,
            ),
          )
        : Container(
            padding: const EdgeInsets.all(5),
            alignment: Alignment.center,
            constraints: BoxConstraints(maxWidth: pageWidth),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/home-bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: Colors.black,
                    height: 20,
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 20, bottom: 10),
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: const Text(
                            '',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: const Text(
                            '',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              //TODO: contact us linktree
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.call,
                                  color: Colors.red,
                                ),
                                Text(
                                  'Contact Us',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('images/icon.png'),
                        const SizedBox(
                          width: 10,
                        ),
                        Neon(
                          text: 'BodyForge',
                          color: Colors.red,
                          fontSize: 32,
                          font: NeonFont.Membra,
                          flickeringText: true,
                          flickeringLetters: const [0, 4, 8],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Featured Coaches:',
                                style: GoogleFonts.aclonica(
                                    fontSize: 24, color: Colors.white),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.toNamed('/coaches');
                                },
                                child: Text(
                                  'all coaches',
                                  style: GoogleFonts.aclonica(
                                      fontSize: 14, color: Colors.red.shade700),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FeaturedCoachWidget(
                            coaches: controller.coachList,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Free Books:',
                            style: GoogleFonts.aclonica(
                                fontSize: 24, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BookWidget(
                            books: controller.bookList,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Useful Applications:',
                            style: GoogleFonts.aclonica(
                                fontSize: 24, color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppWidget(
                          apps: controller.appList,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
