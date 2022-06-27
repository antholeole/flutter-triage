import 'package:bug/follower_position_relayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';

void main() {
  runApp(MaterialApp(home: Scaffold(body: MyApp())));
}

class MyApp extends StatelessWidget {
  final loupeLink = LayerLink();
  final text = lorem(paragraphs: 5, words: 500);

  final textController =
      TextEditingController(text: lorem(words: 100, paragraphs: 1));

  static const Offset magnificationOffset = Offset(0, -60);

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    Offset mousePos = Offset.zero;

    return Stack(children: [
      StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                mousePos = details.globalPosition;
              });
            },
            child: Stack(children: [
              Text(text),
              Positioned(
                top: mousePos.dy,
                left: mousePos.dx,
                child: CompositedTransformTarget(
                  link: loupeLink,
                ),
              )
            ]),
          );
        },
      ),
      FollowerPositionRelayerWithOverflowSafety(
        additionalOffset: magnificationOffset,
        follower: CompositedTransformFollower(link: loupeLink),
        relayPosition: Loupe(
        magnificationScale: 1.2,
        offset: magnificationOffset,
        shadowColor: Colors.black,
        size: const Size(100, 100),
        borderRadius: const Radius.circular(20),
        border: Border.all(
            color: Colors.pink, width: 2, strokeAlign: StrokeAlign.center),
        elevation: 12,
      ),
      ),
    ]);
  }
}
