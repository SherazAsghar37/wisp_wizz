import 'package:flutter/material.dart';
import 'package:wisp_wizz/features/app/helper/dimensions.dart';
import 'package:wisp_wizz/features/chat/presentation/bloc/user-chats/user_chats_bloc.dart';
import 'package:wisp_wizz/features/user/presentation/utils/exports.dart';

class CustomTabBar extends StatefulWidget {
  final List<IconData> tabs;
  final TabController tabController;
  final List<bool> notifications;
  const CustomTabBar(
      {super.key,
      required this.tabs,
      required this.tabController,
      required this.notifications});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  double selectedIndex = 0;

  double getAnimationFormula(int index) {
    switch (index) {
      case 0:
        return selectedIndex > 1 ? 0 : 1 - selectedIndex;
      case 1:
        return selectedIndex < 1 ? selectedIndex : (2 - selectedIndex);
      case 2:
        return selectedIndex < 1 ? 0 : selectedIndex - 1;
      default:
        return 0;
    }
  }

  @override
  void initState() {
    widget.tabController.animation!.addListener(() {
      setState(() {
        selectedIndex = widget.tabController.animation?.value ?? 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userChatsState = context.watch<UserChatsBloc>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Dimensions.height50,
          child: Stack(
            children: [
              SizedBox(
                height: Dimensions.height50,
                child: Align(
                  alignment: FractionalOffset(
                      1 / (widget.tabs.length - 1) * selectedIndex, 0),
                  child: FractionallySizedBox(
                    widthFactor: 1 / widget.tabs.length,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: Dimensions.height30),
                        child: CircleAvatar(
                          radius: Dimensions.height3,
                          backgroundColor: theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: widget.tabs
                    .asMap()
                    .entries
                    .map(
                      (e) => CustomTabBarElement(
                          index: e.key,
                          onPressed: () async {
                            widget.tabController.animateTo(e.key,
                                duration: const Duration(milliseconds: 300));
                          },
                          value: getAnimationFormula(e.key),
                          tabs: widget.tabs,
                          hasNotification:
                              userChatsState is UsersChatsFetched &&
                                      userChatsState.totalUnreadMessages > 0 &&
                                      e.key == 0
                                  ? true
                                  : false),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomTabBarElement extends StatelessWidget {
  final int index;
  final VoidCallback onPressed;
  final double value;
  final List tabs;
  final bool hasNotification;
  const CustomTabBarElement(
      {super.key,
      required this.index,
      required this.onPressed,
      required this.value,
      required this.tabs,
      required this.hasNotification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
        height: Dimensions.height60,
        width: Dimensions.width60,
        child: TextButton(
          onPressed: onPressed,
          child: Stack(
            children: [
              hasNotification
                  ? Align(
                      alignment: FractionalOffset(1, -value * 0.2),
                      child: CircleAvatar(
                        radius: Dimensions.height4,
                        backgroundColor: theme.colorScheme.secondary,
                      ),
                    )
                  : const SizedBox(),
              Center(
                child: Align(
                  alignment: FractionalOffset(0.3, -value * 1),
                  child: Stack(
                    children: [
                      Icon(
                        tabs[index],
                        size: Dimensions.height30,
                        color: Color.lerp(theme.colorScheme.primary,
                            theme.primaryColor, value)!,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
