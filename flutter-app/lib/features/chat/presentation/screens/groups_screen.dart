import 'package:flutter/material.dart';
import 'package:wisp_wizz/features/app/utils/dimensions.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width5, vertical: Dimensions.height5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Groups",
            style: theme.textTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}
