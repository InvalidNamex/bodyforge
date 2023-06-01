import 'package:flutter/material.dart';

import '../constants.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > pageWidth) {
            return Center(
              child: Container(
                width: pageWidth,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: buildContent(context),
              ),
            );
          } else {
            return buildContent(context);
          }
        },
      ),
    );
  }
}

Widget buildContent(context) => Container(
    padding: const EdgeInsets.all(5),
    alignment: Alignment.center,
    constraints: BoxConstraints(maxWidth: pageWidth),
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('images/home-bg.png'),
        fit: BoxFit.fill,
      ),
    ),
    child: Center(
      child: Text(''),
    ));
