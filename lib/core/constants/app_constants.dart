class AppConstants {
  AppConstants._();

  static const String serverUrl = "";
  static const String ipAddress = " 192.168.1.4";
  static const String baseUrl = "https://chat-server-ff1g.onrender.com";

  static const String token = "token";
  static const String expiresAt = "expiresAt";
  static const String userId = "userId";

  static const iOSException = 'Invalid lambda function output';
  static const iOSExceptionAmplify =
      'invalid_request: PreSignUp failed with error Account linked successfully.';

  static const login = 'login Successfully';
  static const logout = 'logout Successfully';
  static const mobileNoExc =
      'PreSignUp failed with error Phone number already in use.';
  static int statusCode = 201;
  static int statusCode2001 = 200;

// for checking null value
  static bool checkStatusCode(status) {
    if (status == statusCode || status == statusCode2001) {
      return true;
    } else {
      return false;
    }
  }
}
