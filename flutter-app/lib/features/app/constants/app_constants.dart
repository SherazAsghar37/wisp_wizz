const String appName = 'Wip Wiz';
// const String baseUrl = "http://127.0.0.1:8000";
const String baseUrl = "http://192.168.1.106:8000";
const String sendCodeUrl = "/auth/verification/sendOtp";
const String verifyOTPUrl = "/auth/verification/verifyOtp";
const String loginUrl = "/auth/login";
const String getUserUrl = "/user/getUser";
const String imageFileName = "profilePic";
const dCountryCode = "+92";
const dFlagCode = "PK";

RegExp contryCodeRegex = RegExp(r'\[([^\]]*)\]');
const int verificationCodeLength = 6;

//fileManager
const String mediaFolder = "media";
const String profilePicturesFolder = "profile_pictures";
