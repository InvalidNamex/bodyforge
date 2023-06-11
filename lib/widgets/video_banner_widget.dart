import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:video_player/video_player.dart';

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
                        color: Colors.black.withOpacity(0.4),
                        alignment: Alignment.center,
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText('This is the first line of text',
                                textStyle: const TextStyle(
                                    fontSize: 32, color: Colors.red)),
                            RotateAnimatedText(
                                'This is the second line of te≈†',
                                textStyle: const TextStyle(
                                    fontSize: 32, color: Colors.red)),
                            FadeAnimatedText(
                                'This is the third animated line of text',
                                textStyle: const TextStyle(
                                    fontSize: 32, color: Colors.red)),
                            TypewriterAnimatedText(
                                'This my friend is the fourth line of text',
                                textStyle: const TextStyle(
                                    fontSize: 32, color: Colors.red),
                                cursor: '|'),
                          ],
                        )),
                  )
                ],
              )
            : const SpinKitPumpingHeart(
                color: Colors.red,
              ));
  }
}
