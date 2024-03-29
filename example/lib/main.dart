import 'dart:math';

import 'package:collapsible_app_bar/collapsible_app_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Collapsible App Bar Example'),
        ),
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return const CollapsibleAppBarPage();
                }));
              },
              child: const Text('Open')),
        ));
  }
}

class CollapsibleAppBarPage extends StatefulWidget {
  const CollapsibleAppBarPage({Key? key}) : super(key: key);

  @override
  State<CollapsibleAppBarPage> createState() => _CollapsibleAppBarPageState();
}

class _CollapsibleAppBarPageState extends State<CollapsibleAppBarPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  bool appBarCollapsed = false;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CollapsibleAppBar(
        // Callback after the leading icon is clicked, usually go back.
        onPressedBack: () {
          Navigator.pop(context);
        },
        // The title text displayed when the app bar is collapsed.
        shrinkTitle: 'Do you like it?',
        forceElevated: true,
        elevation: 0.3,
        // We can listen for the collapsed status change.
        onChange: (collapsed) {
          setState(() {
            appBarCollapsed = collapsed;
          });
        },
        // Set the header's height, this must be set according to your header's height.
        expandedHeight: 250,
        // The header can be any widget, as long as its height is in bound.
        header: _buildHeader(context),
        // Here we use TabBar as the header bottom, and we will use the default heightBottomHeight.
        headerBottom: _buildHeaderBottom(context),
        // The body contains TabBarView so we don't want to use ScrollContentWrapper,
        // but we should use wrapper for the children of the TabBarView in order
        // to avoid the overlap of the body's content.
        userWrapper: false,
        body: _buildBody(context),
      ),
      floatingActionButton: _buildFab(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width,
          child: Image.network(
            'https://img.yzcdn.cn/vant/cat.jpeg',
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 50,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: const Text(
            'This is an example with tabs',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 10,
          color: Colors.grey[100],
        ),
      ],
    );
  }

  Widget _buildHeaderBottom(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelColor: Colors.black87,
      labelPadding: const EdgeInsets.only(bottom: 8),
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      indicatorSize: TabBarIndicatorSize.label,
      tabs: const [
        Text('Tab One'),
        Text('Tab Two'),
        Text('Tab Three'),
      ],
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'The App Bar is ${appBarCollapsed ? 'COLLAPSED' : 'EXPANDED'}')));
      },
      child: Icon(
        appBarCollapsed
            ? Icons.arrow_circle_up_outlined
            : Icons.arrow_circle_down_outlined,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return TabBarView(controller: tabController, children: [
      ScrollContentWrapper(child: _buildTab()),
      ScrollContentWrapper(child: _buildTab()),
      ScrollContentWrapper(child: _buildTab()),
    ]);
  }

  Widget _buildTab() {
    var colors = [
      Colors.amber,
      Colors.blue,
      Colors.cyan,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.yellow,
    ];

    colors.shuffle(Random());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: colors.map((color) => _containerWithColor(color)).toList(),
      ),
    );
  }

  Widget _containerWithColor(Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
