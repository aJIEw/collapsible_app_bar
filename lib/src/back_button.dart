import 'package:flutter/material.dart';

class AdaptableBackButton extends StatelessWidget {
  const AdaptableBackButton({
    Key? key,
    this.showBackground = false,
    this.backgroundColor,
    this.onPressedBack,
    this.child,
  }) : super(key: key);

  final bool showBackground;

  final Color? backgroundColor;

  final VoidCallback? onPressedBack;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: showBackground
              ? backgroundColor ?? Colors.black38
              : Colors.transparent,
        ),
        child: child ?? Icon(
          Icons.arrow_back_ios_rounded,
          color: showBackground ? Colors.white : Colors.grey[700],
          size: 20,
        ),
      ),
      onTap: () {
        onPressedBack?.call();
      },
    );
  }
}
