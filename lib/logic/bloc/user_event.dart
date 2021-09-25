part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class UserLoaded extends UserEvent {}

class UserAdded extends UserEvent {
  final CurrentUser user;
  UserAdded({
    required this.user,
  });
}

class UserUpdated extends UserEvent {
  final CurrentUser user;
  UserUpdated({
    required this.user,
  });
}

class UserDeleted extends UserEvent {
  final String userCode;
  UserDeleted({
    required this.userCode,
  });
}

class SignInRequested extends UserEvent{
  final String mobileNo;
  final String password;
  SignInRequested({
    required this.mobileNo,
    required this.password,
  });
}

class LogOut extends UserEvent{}


