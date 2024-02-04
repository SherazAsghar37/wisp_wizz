import 'package:flutter/material.dart';
import 'package:wisp_wizz/features/app/constants/screen_constants.dart';
import 'package:wisp_wizz/features/app/helper/dimensions.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';
import 'package:wisp_wizz/features/chat/presentation/widgets/single_chat_card.dart';

class SingleChatScreen extends StatelessWidget {
  static const String routeName = singleChatScreen;
  final UserModel user;
  const SingleChatScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width10,
              ),
              child: SingleChatCard(
                user: user,
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
