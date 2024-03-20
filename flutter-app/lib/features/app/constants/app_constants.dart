import 'package:wisp_wizz/features/app/helper/dimensions.dart';

const String appName = 'Wisp Wiz';
const String dbName = 'wispwiz';
// const String baseUrl = "http://127.0.0.1:8000";
const String base = "http://192.168.1.102:";
const String baseUrl = "${base}8000";
const String socketIOBaseUrl = "${base}8001";
const String sendCodeUrl = "/auth/verification/sendOtp";
const String verifyOTPUrl = "/auth/verification/verifyOtp";
const String loginUrl = "/auth/login";
const String getUserUrl = "/user/getUser";
const String updateUserUrl = "/user/updateUser";
const String getContactsUrl = "$baseUrl/user/getContacts";
const String imageFileName = "profilePic";
const String dCountryCode = "+92";
const String dFlagCode = "PK";

RegExp contryCodeRegex = RegExp(r'\[([^\]]*)\]');
const int verificationCodeLength = 6;

//fileManager
const String mediaFolder = "media";
const String profilePicturesFolder = "profile_pictures";

//sharedpreferences
const String sUserDataKey = "shared-user-data-key";

//
final double notificationIconRadius = Dimensions.height12;

final double borderRadius = Dimensions.height10;
const String appDefaultPic =
    "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";

//sqflite
int chatsLoadAtEachTime = 10;
int messagesLoadAtEachTime = 20;
