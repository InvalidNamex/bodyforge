import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neon/neon.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:get/get.dart';

import '../constants.dart';

class NotFound extends StatelessWidget {
  const NotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Page not found',
              style: GoogleFonts.aclonica(color: accentColor, fontSize: 32),
            ),
            GestureDetector(
              onTap: () async {
                String url = 'https://linktr.ee/a7madhassan';
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(url);
                } else {
                  Get.defaultDialog(
                    title: 'Sorry',
                    content: const Text('We are facing technical difficulties'),
                  );
                }
              },
              child: Neon(
                  text: 'Contact Us',
                  color: Colors.yellow,
                  font: NeonFont.Membra),
            ),
          ],
        ),
      ),
    );
  }
}
