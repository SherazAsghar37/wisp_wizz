import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:wisp_wizz/features/app/config/extensions.dart';
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
        margin: EdgeInsets.symmetric(
            horizontal: Dimensions.width10, vertical: Dimensions.height5),
        height: Dimensions.height60,
        width: Dimensions.screenWidth,
        padding: EdgeInsets.fromLTRB(Dimensions.width5, Dimensions.height5,
            Dimensions.width5, Dimensions.height5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
          // boxShadow: [
          //   BoxShadow(
          //       color: theme.colorScheme.background,
          //       blurRadius: 10,
          //       offset: const Offset(0, 5))
          // ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(arrowBack)),
                CachedNetworkImage(
                  imageUrl: baseUrl + user.image,
                  key: ValueKey(Random().nextInt(100)),
                  placeholder: (context, url) => CircularProgressIndicator(
                    strokeWidth: 1,
                    color: theme.primaryColor,
                  ),
                  errorWidget: (context, url, error) => CircleAvatar(
                      radius: radius,
                      backgroundImage: Image.asset("images/profile.png").image),
                  imageBuilder: (context, imageProvider) {
                    return CircleAvatar(
                        radius: radius, backgroundImage: imageProvider);
                  },
                ),
                // CircleAvatar(
                //   radius: radius,
                //   backgroundImage: Utils.getUserImage(user),
                // ),
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
                                radius: Dimensions.height3,
                                backgroundColor: greenColor,
                              )
                            : const SizedBox(),
                        user.status
                            ? SizedBox(
                                width: Dimensions.width3,
                              )
                            : const SizedBox(),
                        SizedBox(
                          width: Dimensions.screenWidth * 0.45,
                          child: Text(
                              user.status
                                  ? "Online"
                                  : user.lastSeen.timeFormat(),
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
