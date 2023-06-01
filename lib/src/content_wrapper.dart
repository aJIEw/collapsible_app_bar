import 'package:flutter/material.dart';

/// This is a wrapper widget that handles the header's overlap area.
class ScrollContentWrapper extends StatelessWidget {
  const ScrollContentWrapper({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return CustomScrollView(
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverToBoxAdapter(
            child: child,
          ),
        ],
      );
    });
  }
}
