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
    this.headerBottom,
    this.bottomHeight = 24,
    this.userWrapper = true,
    required this.body,
  }) : super(key: key);

  /// If not specified, [Icons.arrow_back_ios_rounded] will be used.
  final IconData? leadingIcon;

  /// Callback for leading icon click.
  final VoidCallback? onPressedBack;

  /// Don't display leading icon, defaults to false.
  final bool hideLeadingIcon;

  /// String title when app bar is collapsed.
  final String? shrinkTitle;

  final TextStyle? shrinkTitleStyle;

  /// Whether the title is center displayed, defaults to true.
  final bool centerTitle;

  /// The app bar elevation.
  final double? elevation;

  /// Defaults to false.
  final bool forceElevated;

  /// Whether the app bar is pinned after collapsed, defaults to true.
  final bool pinned;

  /// The [actions] widgets will be wrapped with [ActionButton],
  /// so that they will have a translucent background when expanded.
  final List<Widget>? actions;

  /// This determines when is the app bar considered collapsed, defaults to 150.
  ///
  /// If your [flexibleSpace] widget's height is much smaller or larger then this,
  /// then you may consider to adjust this property.
  final double scrollShrinkThreshold;

  /// This is the height of the [flexibleSpace] when expanded. You should set
  /// this value according to the height of your [flexibleSpace].
  final double expandedHeight;

  /// The widget inside a pinned [FlexibleSpaceBar], the header.
  final Widget? flexibleSpace;

  /// The [AppBar.bottom] widget in case you want to have a sticky bottom at the
  /// bottom of the app bar, e.g. when you have a tab bar under app bar.
  final Widget? headerBottom;

  /// The height of the [headerBottom] widget, defaults to 24.
  ///
  /// This only determines how tall it will look like when collapsed,
  /// because when expanded, the height is not restricted at all.
  final double bottomHeight;

  /// Whether to use [ScrollContentWrapper] or not, defaults to true.
  /// If you are using tab bar, then you may set this to false, and use
  /// [ScrollContentWrapper] to wrap your tab bar view's children.
  final bool userWrapper;

  /// The body under the app bar.
  final Widget body;

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
          icon: widget.leadingIcon,
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

  PreferredSizeWidget? _buildHeaderBottom(BuildContext context) {
    return widget.headerBottom != null
        ? PreferredSize(
            preferredSize: Size.fromHeight(widget.bottomHeight),
            child: widget.headerBottom!,
          )
        : null;
  }

  Widget _buildBodyContent(BuildContext context) {
    return widget.userWrapper
        ? ScrollContentWrapper(child: widget.body)
        : widget.body;
  }
}
