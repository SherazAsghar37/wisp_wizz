import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';

class ContactCard extends StatelessWidget {
  final UserModel user;
  ContactCard({
    super.key,
    required this.user,
  });

  final double radius = Dimensions.height13 + Dimensions.width13;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return SizedBox(
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
              Text(
                user.name,
                style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.primaryColorDark,
                    fontSize: Dimensions.height18),
              ),
            ],
          ),
          const Icon(chatIcon)
        ],
      ),
    );
  }
}
