import 'package:flutter/material.dart';

import '../index.dart';

class CommonScaffold extends StatelessWidget {
  const CommonScaffold({
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.hideKeyboardWhenTouchOutside = false,
    this.shimmerEnabled = false,
    this.scaffoldKey,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool hideKeyboardWhenTouchOutside;
  final bool shimmerEnabled;
  final Key? scaffoldKey;

  @override
  Widget build(BuildContext context) {
// ignore: prefer_common_widgets
    final scaffold = Scaffold(
      key: scaffoldKey,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor ?? cl.white,
      body: shimmerEnabled ? Shimmer(child: body) : body,
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
    );

    final scaffoldWithBanner = Env.flavor == Flavor.production
        ? scaffold
        : Banner(
            location: BannerLocation.topStart,
            message: Env.flavor.name,
            // ignore: avoid_hard_coded_colors
            color: Colors.green.withOpacity(0.6),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 1,
            ),
            textDirection: TextDirection.ltr,
            child: scaffold,
          );

    return hideKeyboardWhenTouchOutside
        ? GestureDetector(
            onTap: () => ViewUtil.hideKeyboard(context),
            child: scaffoldWithBanner,
          )
        : scaffoldWithBanner;
  }
}
