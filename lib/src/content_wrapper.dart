import 'package:flutter/material.dart';

class ScrollContentWrapper extends StatelessWidget {
  const ScrollContentWrapper({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return CustomScrollView(
        slivers: [
          SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
          SliverToBoxAdapter(
            child: child,
          ),
        ],
      );
    });
  }
}
