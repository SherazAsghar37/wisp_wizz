import 'package:dartz/dartz.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/contacts/data/datasources/contacts_data_source.dart';
import 'package:wisp_wizz/features/contacts/data/datasources/contacts_local_dataource.dart';
import 'package:wisp_wizz/features/contacts/domain/repository/i_contacts_repository.dart';
import 'package:wisp_wizz/features/contacts/data/models/contact_model.dart';

class ContactReposiotry extends IContactReposiotry {
  final ContactDatasource contactDatasource;
  final ContactLocalDatasource contactLocalDatasource;
  ContactReposiotry(
      {required this.contactDatasource, required this.contactLocalDatasource});

  @override
  ResultFuture<List<ContactModel>> fetchContacts() async {
    try {
      final contacts = await contactLocalDatasource.fetchContacts();

      return right(contacts);
    } on ContactException catch (e) {
      return Left(ContactFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<ContactModel>> fetchServerContacts() async {
    try {
      final contacts = await contactDatasource.readContacts();
      await contactLocalDatasource.saveContacts(contacts);
      return right(contacts);
    } on ContactException catch (e) {
      return Left(ContactFailure.fromException(e));
    }
  }
}
