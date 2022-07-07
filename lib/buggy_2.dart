import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyBuggy());
}

class MyBuggy extends StatefulWidget {
  static const size = Size(20, 100);

  const MyBuggy({super.key});

  @override
  State<MyBuggy> createState() => _MyBuggyState();
}

class _MyBuggyState extends State<MyBuggy> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  final LayerLink link = LayerLink();

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true)
          ..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = const Size(500, 500);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.blue,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // This compositedTransformTarget oscilates back and forth across the width
          // on the screen.
          Align(
            alignment: Alignment.centerLeft,
            child: Transform.translate(
              offset: Offset((animationController.value) * screenSize.width, 0),
              child: CompositedTransformTarget(link: link),
            ),
          ),
          // This is the red rectangle.
          CompositedTransformFollower(
            link: link,
            child: Container(
              color: Colors.red,
              width: MyBuggy.size.width,
              height: MyBuggy.size.height,
            ),
          ),
          // The applied image filter.
          SizedBox.fromSize(
            size: MediaQuery.of(context).size / 2,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.matrix(
                    (Matrix4.identity()..translate(100.0, 100.0)).storage),
                child: Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
          ),
          //for visibility. Wraps the BackdropFilter with a black border
          //so we can see where it applies.
          Container(
            width: screenSize.width / 2,
            height: screenSize.height / 2,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2)),
          )
        ],
      ),
    );
  }
}
