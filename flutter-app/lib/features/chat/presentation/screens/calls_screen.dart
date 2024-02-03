import 'package:flutter/material.dart';
import 'package:wisp_wizz/features/app/shared/widgets/notification_icon.dart';
import 'package:wisp_wizz/features/app/utils/dimensions.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

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
          Row(
            children: [
              Text(
                "Calls",
                style: theme.textTheme.bodyLarge!
                    .copyWith(color: theme.primaryColorDark),
              ),
              SizedBox(
                width: Dimensions.width5,
              ),
              const NotificationIcon(
                notifications: "1",
              )
            ],
          ),
          Text(
            "Recent",
            style: theme.textTheme.bodyMedium!
                .copyWith(color: colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
