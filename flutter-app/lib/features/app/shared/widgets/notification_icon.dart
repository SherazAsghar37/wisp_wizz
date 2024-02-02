import 'package:flutter/material.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/utils/dimensions.dart';

class NotificationIcon extends StatelessWidget {
  final String notifications;
  const NotificationIcon({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return notifications.length == 1
        ? CircleAvatar(
            radius: notificationIconRadius,
            backgroundColor: colorScheme.secondary,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: Dimensions.height2),
                child: Text(
                  notifications,
                  style: theme.textTheme.bodySmall!
                      .copyWith(color: colorScheme.shadow),
                ),
              ),
            ),
          )
        : Container(
            height: notificationIconRadius * 2,
            padding: EdgeInsets.fromLTRB(
              Dimensions.width5,
              0,
              Dimensions.width5,
              Dimensions.height2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.height10),
              color: colorScheme.secondary,
            ),
            child: Center(
              child: Text(
                notifications.length > 4
                    ? "${notifications.substring(0, 4)}+"
                    : notifications,
                style: theme.textTheme.bodySmall!
                    .copyWith(color: colorScheme.shadow),
              ),
            ),
          );
  }
}
