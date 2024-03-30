import 'package:wisp_wizz/features/contacts/presentation/utils/contacts_exports.dart';

class ContactsScreen extends StatefulWidget {
  static const String routeName = contactsScreen;
  final UserModel user;
  const ContactsScreen({super.key, required this.user});

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
                    height: Dimensions.height10,
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
                    height: Dimensions.height20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${state is ContactsFetched ? state.contacts.length : 0} Contacts",
                        style: theme.textTheme.bodyMedium,
                      ),
                      state is ContactsFetching || state is LocalContactsFetched
                          ? SizedBox(
                              height: Dimensions.height15,
                              width: Dimensions.width15,
                              child: CircularProgressIndicator(
                                color: theme.primaryColor,
                                strokeWidth: Dimensions.width1,
                              ))
                          : const SizedBox()
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.height10,
                  ),
                  Expanded(
                    child: RefreshIndicator(
                        color: theme.primaryColor,
                        onRefresh: () async {
                          context
                              .read<ContactBloc>()
                              .add(const ContactFetchEvent());
                        },
                        child: state is ContactsFetched
                            ? ContactsFetchedItemsBuilder(
                                state: state,
                                user: widget.user,
                              )
                            : state is LocalContactsFetched
                                ? LocalContactsFetchedItemsBuilder(
                                    state: state,
                                    user: widget.user,
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                    color: theme.primaryColor,
                                  ))),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
