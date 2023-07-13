import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../constants.dart';
import '../helpers/loader_helper.dart';

class VideoBannerWidget extends StatefulWidget {
  const VideoBannerWidget({Key? key}) : super(key: key);

  @override
  _VideoBannerWidgetState createState() => _VideoBannerWidgetState();
}

class _VideoBannerWidgetState extends State<VideoBannerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('images/banner.mp4')
      ..initialize().whenComplete(() {
        setState(() {
          Future.delayed(const Duration(seconds: 1), () => _controller.play());
          _controller.setVolume(0.0);
          _controller.setLooping(true);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: _controller.value.isInitialized
            ? Stack(
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  Positioned.fill(
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        color: darkColor.withOpacity(0.5),
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedTextKit(
                              onNextBeforePause: (index, isIt) =>
                                  homeController.isButtonVisible(false),
                              onFinished: () =>
                                  homeController.isButtonVisible(true),
                              totalRepeatCount: 1,
                              animatedTexts: [
                                FadeAnimatedText(
                                  'Are you a coach looking to take the next step in your career?',
                                  textStyle: GoogleFonts.aclonica(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: lightColor),
                                ),
                                RotateAnimatedText(
                                  'Are you a trainee trying to get shredded?\n Do you want to put on some muscles?',
                                  textStyle: GoogleFonts.aclonica(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: lightColor),
                                ),
                                FadeAnimatedText(
                                  'Looking for the best coaches to help you achieve your goals effectively?',
                                  textStyle: GoogleFonts.aclonica(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: lightColor),
                                ),
                                TypewriterAnimatedText(
                                  'JOIN US NOW',
                                  textStyle: GoogleFonts.aclonica(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                      color: accentColor),
                                  cursor: '|',
                                  speed: const Duration(milliseconds: 60),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Obx(
                              () => homeController.isButtonVisible.value
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () =>
                                              Get.toNamed('/pricing'),
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      accentColor)),
                                          child: Text('Coach with us',
                                              style: GoogleFonts.aclonica(
                                                  color: darkColor)),
                                        ),
                                        SizedBox(
                                          width: 10,
                                          height: 30,
                                          child: VerticalDivider(
                                            thickness: 2,
                                            color: darkColor,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Get.toNamed('/client-signup');
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      accentColor)),
                                          child: Text('Train with us',
                                              style: GoogleFonts.aclonica(
                                                  color: darkColor)),
                                        )
                                      ],
                                    )
                                  : Container(),
                            ),
                          ],
                        )),
                  ),
                ],
              )
            : Container(
                height: pageWidth * 16 / 9,
                width: pageWidth,
                alignment: Alignment.center,
                child: loader()));
  }
}

//   TyperAnimatedText('This is the first line of text',
//       textStyle: GoogleFonts.aclonica(
//           fontWeight: FontWeight.bold,
//           fontSize: 36,
//           color: lightColor)),
//   RotateAnimatedText(
//       'This is the second line of te≈†',
//       textStyle: GoogleFonts.aclonica(
//           fontWeight: FontWeight.bold,
//           fontSize: 36,
//           color: lightColor)),
//   FadeAnimatedText(
//       'This is the third animated line of text',
//       textStyle: GoogleFonts.aclonica(
//           fontWeight: FontWeight.bold,
//           fontSize: 36,
//           color: lightColor)),
