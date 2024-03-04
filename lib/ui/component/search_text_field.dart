import 'package:flutter/material.dart';

import '../../index.dart';

class SearchTextField extends StatelessWidget {
  final void Function(String)? onChanged;

  const SearchTextField({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      autofocus: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.rps,
        ),
        hintText: l10n.search,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.rps),
        ),
      ),
    );
  }
}
