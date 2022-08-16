library collapsible_app_bar;

import 'dart:io';

import 'package:collapsible_app_bar/src/action_button.dart';
import 'package:flutter/material.dart';

import 'back_button.dart';
import 'content_wrapper.dart';

class CollapsibleAppBar extends StatefulWidget {
  const CollapsibleAppBar({
    Key? key,
    this.leadingIcon,
    this.onPressedBack,
    this.hideLeadingIcon = false,
    this.shrinkTitle,
    this.shrinkTitleStyle,
    this.centerTitle = true,
    this.elevation,
    this.forceElevated = false,
    this.pinned = true,
    this.actions,
    this.scrollShrinkThreshold = 150,
    required this.expandedHeight,
    this.flexibleSpace,
    required this.headerBottom,
    required this.body,
    this.bottomHeight = 24,
    this.userWrapper = true,
  }) : super(key: key);

  final Widget? leadingIcon;

  final VoidCallback? onPressedBack;

  final bool hideLeadingIcon;

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

  final double bottomHeight;

  final bool userWrapper;

  @override
  State<CollapsibleAppBar> createState() => _CollapsibleAppBarState();
}

class _CollapsibleAppBarState extends State<CollapsibleAppBar> {
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
            leading: _buildLeading(),
            title: _buildShrinkTitle(),
            actions: _buildActions(),
            expandedHeight: _buildExpandedHeight(),
            flexibleSpace: _buildFlexibleSpace(context),
            bottom: _buildHeaderBottom(context),
          ),
        ),
      ],
      body: _buildBodyContent(context),
    );
  }

  Widget? _buildLeading() => widget.hideLeadingIcon
      ? null
      : AdaptableBackButton(
          showBackground: !isShrink,
          onPressedBack: widget.onPressedBack,
          child: widget.leadingIcon,
        );

  Widget? _buildShrinkTitle() => Text(
        isShrink ? widget.shrinkTitle ?? '' : '',
        style: widget.shrinkTitleStyle ??
            const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.normal),
      );

  List<Widget>? _buildActions() => widget.actions
      ?.map((btn) => ActionButton(showBackground: !isShrink, child: btn))
      .toList();

  /// On Android, add extra height for status bar, default to 24
  double? _buildExpandedHeight() =>
      widget.expandedHeight + (Platform.isAndroid ? 24 : 0);

  Widget _buildFlexibleSpace(BuildContext context) {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.pin,
      background: widget.flexibleSpace,
    );
  }

  PreferredSizeWidget _buildHeaderBottom(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(widget.bottomHeight),
      child: widget.headerBottom,
    );
  }

  Widget _buildBodyContent(BuildContext context) {
    return widget.userWrapper
        ? ScrollContentWrapper(child: widget.body)
        : widget.body;
  }
}
