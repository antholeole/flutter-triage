import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

mixin AutomaticFragmentReloader<T extends StatefulWidget> on State<T> {
  String get fragmentShaderPath;

  late Future<FragmentProgram> program;

  @override
  void initState() {
    _reloadShader();
    super.initState();
  }

  @override
  void reassemble() {
    _reloadShader();
    super.reassemble();
  }

  void _reloadShader() {
    setState(() {
      program = rootBundle
          .load(fragmentShaderPath)
          .then((data) => FragmentProgram.compile(spirv: data.buffer));
    });
  }
}

class FragmentReloader extends StatefulWidget {
  const FragmentReloader({super.key});

  @override
  State<FragmentReloader> createState() => _FragmentReloaderState();
}

class _FragmentReloaderState extends State<FragmentReloader>
    with AutomaticFragmentReloader {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  String get fragmentShaderPath => 'blah path';
}
