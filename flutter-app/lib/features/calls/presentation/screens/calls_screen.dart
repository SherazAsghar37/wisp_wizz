import 'package:wisp_wizz/features/calls/presentation/utils/exports.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final UserModel user = UserModel.empty();
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Calls",
                style: theme.textTheme.bodyLarge!
                    .copyWith(color: theme.primaryColorDark),
              ),
              SizedBox(
                width: Dimensions.width5,
              ),
              const NotificationIcon(
                notifications: "1",
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: Dimensions.height5),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.height2),
                  child: CallCard(
                    user: user,
                    lastCallTime: DateTime.now(),
                    callStatus: index % 2 == 0 ? "read" : "sent",
                    callType: "video",
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
