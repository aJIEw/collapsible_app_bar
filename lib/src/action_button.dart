import 'dart:io';

import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    required this.showBackground,
    required this.child,
  }) : super(key: key);

  final bool showBackground;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      margin: Platform.isAndroid && !showBackground
          ? const EdgeInsets.only(right: 12)
          : const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: showBackground ? Colors.black38 : Colors.transparent,
      ),
      child: child,
    );
  }
}
