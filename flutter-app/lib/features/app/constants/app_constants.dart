import 'package:wisp_wizz/features/app/helper/dimensions.dart';

const String appName = 'Wisp Wiz';
// const String baseUrl = "http://127.0.0.1:8000";
const String baseUrl = "http://192.168.1.104:8000";
const String sendCodeUrl = "/auth/verification/sendOtp";
const String verifyOTPUrl = "/auth/verification/verifyOtp";
const String loginUrl = "/auth/login";
const String getUserUrl = "/user/getUser";
const String updateUserUrl = "/user/updateUser";
const String imageFileName = "profilePic";
const dCountryCode = "+92";
const dFlagCode = "PK";

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
