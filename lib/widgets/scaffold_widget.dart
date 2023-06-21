import 'package:flutter/material.dart';
import '/constants.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold(
      {Key? key,
      required this.buildContent,
      this.drawer,
      this.appBar,
      this.endDrawer = false})
      : super(key: key);
  final Widget buildContent;
  final Drawer? drawer;
  final AppBar? appBar;
  final bool endDrawer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      drawer: !endDrawer ? drawer : null,
      endDrawer: endDrawer ? drawer : null,
      appBar: appBar,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > pageWidth) {
            return Center(
              child: Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/home-bg.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(maxWidth: pageWidth),
                      color: darkColor.withOpacity(0.5),
                      child: buildContent)),
            );
          } else {
            return Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/home-bg.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: buildContent);
          }
        },
      ),
    );
  }
}
