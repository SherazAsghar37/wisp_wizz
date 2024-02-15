import 'package:wisp_wizz/features/app/shared/widgets/contact_card.dart';
import 'package:wisp_wizz/features/contacts/presentation/bloc/contact_bloc.dart';
import 'package:wisp_wizz/features/user/presentation/utils/exports.dart';

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
    return BlocConsumer<ContactBloc, ContactState>(
      listener: (context, state) {
        if (state is ContactsFetchingFailed) {
          BotToast.showText(
              text: state.message,
              contentColor: theme.primaryColorLight,
              textStyle: theme.textTheme.bodyMedium!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          extendBodyBehindAppBar: true,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(Dimensions.width20,
                  Dimensions.height5, Dimensions.width20, 0),
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
                  SizedBox(
                    height: Dimensions.height10,
                  ),
                  Text(
                    "${state is ContactsFetched ? state.contacts.length : 0} Contacts",
                    style: theme.textTheme.bodyMedium,
                  ),
                  Expanded(
                      child: state is ContactsFetched
                          ? ListView.builder(
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimensions.height5),
                              itemCount: state.contacts.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.height2),
                                  child: ContactCard(
                                    contact: state.contacts[index],
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                              color: theme.primaryColor,
                            ))),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
