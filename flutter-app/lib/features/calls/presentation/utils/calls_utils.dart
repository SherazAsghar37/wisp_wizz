import 'package:flutter/material.dart';
import "dart:math" as math;
import '../../../app/constants/icons_constants.dart';
import '../../../app/theme/colors.dart';
import '../../../app/helper/dimensions.dart';

class CallsUtils {
  static Widget getCallStatusIcon(BuildContext context, String status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case "missedSent":
        return Icon(
          arrowCircleUpLeftIcon,
          color: redColor,
          size: Dimensions.height18,
        );
      case "missedReceived":
        return Transform.rotate(
          angle: math.pi,
          child: Icon(
            arrowCircleUpLeftIcon,
            size: Dimensions.height18,
            color: redColor,
          ),
        );
      case "successfulSent":
        return Icon(
          arrowCircleUpLeftIcon,
          color: greenColor,
          size: Dimensions.height18,
        );
      case "successfulReceived":
        return Transform.rotate(
          angle: math.pi,
          child: Icon(
            arrowCircleUpLeftIcon,
            size: Dimensions.height18,
            color: greenColor,
          ),
        );
      default:
        return Icon(
          clockIcon,
          size: Dimensions.height18,
          color: colorScheme.primary,
        );
    }
  }

  static Widget getCallIcon(BuildContext context, String status, String type) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case "missedSent":
      case "missedReceived":
        switch (type) {
          case "voice":
            return Icon(
              callIcon,
              color: redColor,
              size: Dimensions.height28,
            );
          case "video":
            return Icon(
              videoIcon,
              color: redColor,
              size: Dimensions.height28,
            );
          default:
            return Icon(
              clockIcon,
              size: Dimensions.height28,
              color: colorScheme.primary,
            );
        }

      case "successfulSent":
      case "successfulReceived":
        switch (type) {
          case "voice":
            return Icon(
              callIcon,
              color: greenColor,
              size: Dimensions.height28,
            );
          case "video":
            return Icon(
              videoIcon,
              color: greenColor,
              size: Dimensions.height28,
            );
          default:
            return Icon(
              clockIcon,
              size: Dimensions.height28,
              color: colorScheme.primary,
            );
        }
      default:
        return Icon(
          clockIcon,
          size: Dimensions.height28,
          color: colorScheme.primary,
        );
    }
  }
}
