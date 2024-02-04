import 'package:wisp_wizz/features/app/theme/colors.dart';
import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';

class SingleChatCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onPressed;
  SingleChatCard({
    super.key,
    required this.user,
    required this.onPressed,
  });

  final double radius = Dimensions.height12 + Dimensions.width12;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: SizedBox(
        // color: Colors.blue,
        height: Dimensions.height55,
        width: Dimensions.screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: radius,
                  backgroundColor: colorScheme.primary,
                  child: CircleAvatar(
                    radius: radius - 2,
                    backgroundImage: Utils.getUserImage(user),
                  ),
                ),
                SizedBox(
                  width: Dimensions.width10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: theme.textTheme.bodyLarge!.copyWith(
                          color: theme.primaryColorDark,
                          fontSize: Dimensions.height18),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        user.status
                            ? CircleAvatar(
                                radius: radius,
                                backgroundColor: greenColor,
                              )
                            : const SizedBox(),
                        SizedBox(
                          width: Dimensions.screenWidth * 0.45,
                          child: Text(
                              user.status
                                  ? "Online"
                                  : user.lastSeen.toString().substring(2, 10),
                              maxLines: 1,
                              softWrap: false,
                              style: theme.textTheme.bodySmall!
                                  .copyWith(fontSize: Dimensions.height14)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            MenuItemButton(child: Text(""))
          ],
        ),
      ),
    );
  }
}
