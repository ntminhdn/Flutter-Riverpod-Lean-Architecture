import 'package:flutter/material.dart';

import '../../../index.dart';

class CommonNewPageProgressIndicator extends StatelessWidget {
  const CommonNewPageProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.rps),
        child: const CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
