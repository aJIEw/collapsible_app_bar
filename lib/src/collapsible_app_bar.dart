library collapsible_app_bar;

import 'dart:io';

import 'package:collapsible_app_bar/src/action_button.dart';
import 'package:flutter/material.dart';

import 'back_button.dart';

class CollapsibleAppBar extends StatefulWidget {
  const CollapsibleAppBar({
    Key? key,
    this.onPressedBack,
    this.shrinkTitle,
    this.shrinkTitleStyle,
    this.centerTitle = true,
    this.elevation,
    this.forceElevated = false,
    this.pinned = true,
    this.actions,
    this.scrollShrinkThreshold = 250,
    required this.expandedHeight,
    this.flexibleSpace,
    required this.headerBottom,
    required this.body,
    this.userWrapper = true,
  }) : super(key: key);

  final VoidCallback? onPressedBack;

  final String? shrinkTitle;

  final TextStyle? shrinkTitleStyle;

  final bool centerTitle;

  final double? elevation;

  final bool forceElevated;

  final bool pinned;

  final List<Widget>? actions;

  final double scrollShrinkThreshold;

  final double expandedHeight;

  final Widget? flexibleSpace;

  final Widget headerBottom;

  final Widget body;

  final bool userWrapper;

  @override
  State<CollapsibleAppBar> createState() => _CollapsibleAppBarState();
}

class _CollapsibleAppBarState extends State<CollapsibleAppBar> {
  static const headerBottomSize = 48.0;

  ScrollController scrollController = ScrollController();

  bool isShrink = false;

  bool get _isShrink {
    return scrollController.hasClients &&
        scrollController.offset >
            (widget.scrollShrinkThreshold - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);

    super.dispose();
  }

  void _scrollListener() {
    var cached = _isShrink;
    if (isShrink != cached) {
      setState(() {
        isShrink = cached;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
        SliverOverlapAbsorber(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          sliver: SliverAppBar(
            backgroundColor: Colors.white,
            centerTitle: widget.centerTitle,
            elevation: widget.elevation,
            forceElevated: widget.forceElevated,
            pinned: widget.pinned,
            leading: AdaptableBackButton(
              showBackground: !isShrink,
              onPressedBack: widget.onPressedBack,
            ),
            actions: widget.actions
                ?.map((btn) =>
                    ActionButton(showBackground: !isShrink, child: btn))
                .toList(),
            expandedHeight:
                widget.expandedHeight + (Platform.isAndroid ? 20 : 0),
            title: Text(isShrink ? widget.shrinkTitle ?? '' : '',
                style: widget.shrinkTitleStyle ??
                    const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.normal)),
            flexibleSpace: _buildFlexibleSpace(context),
            bottom: _buildHeaderBottom(context),
          ),
        ),
      ],
      body: _buildBodyContent(context),
    );
  }

  Widget _buildFlexibleSpace(BuildContext context) {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.pin,
      background: widget.flexibleSpace,
    );
  }

  PreferredSizeWidget _buildHeaderBottom(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(headerBottomSize),
      child: widget.headerBottom,
    );
  }

  Widget _buildBodyContent(BuildContext context) {
    return widget.userWrapper
        ? scrollContentWrapper(context, child: widget.body)
        : widget.body;
  }

  Widget scrollContentWrapper(BuildContext context, {required Widget child}) {
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
