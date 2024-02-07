import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';

class AttachmentButton extends StatelessWidget {
  final IconData icon;
  final String name;
  final VoidCallback onPresed;
  const AttachmentButton({
    super.key,
    required this.icon,
    required this.name,
    required this.onPresed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      // splashColor: theme.primaryColorLight,
      onPressed: onPresed,

      // padding: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            icon,
            size: Dimensions.height30,
            color: theme.primaryColor,
          ),
          Text(
            name,
            style:
                theme.textTheme.bodySmall!.copyWith(color: theme.shadowColor),
          )
        ],
      ),
    );
  }
}
