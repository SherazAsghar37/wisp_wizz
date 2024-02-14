import 'package:wisp_wizz/features/app/shared/widgets/contact_card.dart';
import 'package:wisp_wizz/features/user/presentation/utils/exports.dart';
import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';

class ContactsScreen extends StatefulWidget {
  static const String routeName = contactsScreen;
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final UserModel user = UserModel.empty();
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(Dimensions.width20, Dimensions.height5,
              Dimensions.width20, Dimensions.height30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Contacts",
                style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.primaryColor, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: Dimensions.height5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PrimaryIcon(
                    iconData: arrowBack,
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(
                      height: Dimensions.height40,
                      width: Dimensions.screenWidth -
                          Dimensions.width50 -
                          Dimensions.width20 * 2,
                      child: InputField(
                          controller: searchController, hintText: "Search"))
                ],
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.height5),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: Dimensions.height2),
                      child: ContactCard(
                        user: user,
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
      ),
    );
  }
}
