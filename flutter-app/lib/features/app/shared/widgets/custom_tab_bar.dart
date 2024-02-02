import 'package:flutter/material.dart';
import 'package:wisp_wizz/features/app/shared/widgets/notification_icon.dart';
import 'package:wisp_wizz/features/app/utils/dimensions.dart';

class CustomTabBar extends StatefulWidget {
  final List<IconData> tabs;
  final TabController tabController;
  const CustomTabBar(
      {super.key, required this.tabs, required this.tabController});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  final Duration animationDuration = const Duration(milliseconds: 300);
  int selectedIndex = 0;

  String getMessage() {
    switch (selectedIndex) {
      case 0:
        return "Chats";
      case 1:
        return "Groups";
      case 2:
        return "Calls";
      default:
        return "Chats";
    }
  }

  String message = "Chats";

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
    animation = Tween<double>(begin: 1.0, end: 0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeIn));
    widget.tabController.addListener(() {
      if (widget.tabController.indexIsChanging) {
        setState(() {
          selectedIndex = widget.tabController.index;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    Color selectedColor = theme.primaryColor;
    Color unSelectedColor = colorScheme.shadow.withOpacity(0.2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeTransition(
          opacity: animation,
          child: Row(
            children: [
              Text(
                message,
                style: theme.textTheme.bodyLarge!
                    .copyWith(color: theme.primaryColorDark),
              ),
              SizedBox(
                width: Dimensions.width5,
              ),
              const NotificationIcon(
                notifications: "5",
              )
            ],
          ),
        ),
        SizedBox(
          width: Dimensions.width5,
        ),
        SizedBox(
          height: Dimensions.height60,
          child: Stack(
            children: [
              SizedBox(
                height: Dimensions.height60,
                child: AnimatedAlign(
                  duration: animationDuration,
                  curve: Curves.easeInOut,
                  alignment: FractionalOffset(
                      1 / (widget.tabs.length - 1) * selectedIndex, 0),
                  child: FractionallySizedBox(
                    widthFactor: 1 / widget.tabs.length,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: Dimensions.height20),
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
                children: widget.tabs.asMap().entries.map((e) {
                  final i = e.key;
                  final val = e.value;
                  final isAvtive = i == selectedIndex;
                  return Expanded(
                      child: TextButton(
                    onPressed: () async {
                      widget.tabController.animateTo(i);
                      await animationController.forward();
                      message = getMessage();
                      await animationController.reverse();
                    },
                    child: AnimatedContainer(
                      duration: animationDuration,
                      curve: Curves.easeInOut,
                      child: AnimatedSlide(
                        duration: animationDuration,
                        offset: Offset(0, isAvtive ? -0.15 : 0),
                        child: Icon(
                          val,
                          size: Dimensions.height30,
                          color: isAvtive ? selectedColor : unSelectedColor,
                        ),
                      ),
                    ),
                  ));
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
