import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:wisp_wizz/features/auth/presentation/utils/exports.dart';

// ignore: must_be_immutable
class UserRegistrationScreen extends StatelessWidget {
  static const String routeName = serRegistrationScreen;
  UserRegistrationScreen({super.key});
  File? image;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: colorScheme.background,
      extendBodyBehindAppBar: true,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.fromLTRB(Dimensions.width20, Dimensions.height30,
            Dimensions.width20, Dimensions.height30),
        child: Column(
          children: [
            CircleAvatar(
                // backgroundImage: image==null?"",
                )
          ],
        ),
      )),
    );
  }
}
