import 'package:wisp_wizz/features/app/theme/colors.dart';
import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';

class SingleChatCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onPressed;
  final Function(String value) onSelected;
  final Color color;
  SingleChatCard({
    super.key,
    required this.user,
    required this.onPressed,
    required this.onSelected,
    required this.color,
  });

  final double radius = Dimensions.height10 + Dimensions.width10;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        height: Dimensions.height70,
        width: Dimensions.screenWidth,
        padding: EdgeInsets.fromLTRB(Dimensions.width5, Dimensions.height5,
            Dimensions.width5, Dimensions.height5),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(borderRadius),
                bottomRight: Radius.circular(borderRadius))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(arrowBack)),
                CircleAvatar(
                  radius: radius,
                  backgroundImage: Utils.getUserImage(user),
                ),
                SizedBox(
                  width: Dimensions.width10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                              style: theme.textTheme.bodySmall!.copyWith(
                                  color: user.status ? greenColor : null)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            PopupMenuButton<String>(
              onSelected: onSelected,
              itemBuilder: (BuildContext context) {
                return {"settings"}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
      ),
    );
  }
}
