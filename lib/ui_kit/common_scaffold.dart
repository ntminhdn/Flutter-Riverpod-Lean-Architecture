import 'package:flutter/material.dart';

import '../index.dart';

class CommonScaffold extends StatelessWidget {
  const CommonScaffold({
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.drawer,
    super.key,
    this.backgroundColor,
    this.hideKeyboardWhenTouchOutside = false,
    this.shimmerEnabled = false,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool hideKeyboardWhenTouchOutside;
  final bool shimmerEnabled;

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      backgroundColor: backgroundColor ?? cl.white,
      body: shimmerEnabled ? Shimmer(child: body) : body,
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
    );

    return hideKeyboardWhenTouchOutside
        ? GestureDetector(
            onTap: () => ViewUtil.hideKeyboard(context),
            child: scaffold,
          )
        : scaffold;
  }
}
