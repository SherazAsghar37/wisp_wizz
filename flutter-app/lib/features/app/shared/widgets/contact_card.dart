import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';
import 'package:wisp_wizz/features/contacts/data/models/contact_model.dart';

class ContactCard extends StatelessWidget {
  final ContactModel contact;
  ContactCard({
    super.key,
    required this.contact,
  });

  final double radius = Dimensions.height13 + Dimensions.width13;
  @override
  Widget build(BuildContext context) {
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
                backgroundImage: Utils.getUserImageFromUint8List(contact.image),
              ),
              SizedBox(
                width: Dimensions.width10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    contact.name,
                    style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.primaryColorDark,
                        fontSize: Dimensions.height18),
                  ),
                  Text(
                    contact.phoneNumber,
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontSize: Dimensions.height13),
                  ),
                ],
              ),
            ],
          ),
          const Icon(chatIcon)
        ],
      ),
    );
  }
}
