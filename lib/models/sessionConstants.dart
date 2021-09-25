import 'package:evoter/models/user.dart';

class SessionConstants {
  
  static const sessionUid = "sessionUid";
  static const sessionUsername = 'sessionUsername';

  static CurrentUser? sessionUser; //[phone Number, email]

  static void clear() {
    sessionUser = CurrentUser();
    
  }
  // statsic const profileImage
}