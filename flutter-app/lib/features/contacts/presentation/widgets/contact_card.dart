import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';
import 'package:wisp_wizz/features/contacts/data/models/contact_model.dart';

class ContactCard extends StatelessWidget {
  final ContactModel contact;
  final bool isLoading;
  ContactCard({
    super.key,
    required this.contact,
    required this.isLoading,
  });

  final double radius = Dimensions.height13 + Dimensions.width13;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height2),
      child: SizedBox(
        // color: Colors.blue,
        height: Dimensions.height55,
        width: Dimensions.screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: baseUrl + contact.image,
                  key: ValueKey(Random().nextInt(100)),
                  placeholder: (context, url) => CircleAvatar(
                      radius: radius,
                      backgroundImage: Image.asset("images/profile.png").image),
                  errorWidget: (context, url, error) => CircleAvatar(
                      radius: radius,
                      backgroundImage: Image.asset("images/profile.png").image),
                  imageBuilder: (context, imageProvider) {
                    return CircleAvatar(
                        radius: radius, backgroundImage: imageProvider);
                  },
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
            SizedBox(
              height: Dimensions.height15,
              width: Dimensions.width15,
              child: isLoading
                  ? CircularProgressIndicator(
                      color: theme.primaryColor,
                      strokeWidth: Dimensions.width1,
                    )
                  : Icon(
                      chatIcon,
                      color: theme.primaryColor,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
