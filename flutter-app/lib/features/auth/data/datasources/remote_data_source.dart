import 'dart:io';
import 'package:wisp_wizz/features/app/utils/typedef.dart';

abstract class RemoteDatasource {
  @override
  FutureVoid loginUser(
      {required String name,
      required int phoneNumber,
      required String countryCode,
      File? image}) {
    // TODO: implement sendCode
    throw UnimplementedError();
  }

  @override
  FutureVoid sendCode({required int phoneNumber, required String countryCode}) {
    // TODO: implement sendCode
    throw UnimplementedError();
  }

  @override
  FutureVoid verifyOTP({required int phoneNumber, required int otp}) {
    // TODO: implement verifyOTP
    throw UnimplementedError();
  }
}
