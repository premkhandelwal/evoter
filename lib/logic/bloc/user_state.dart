part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UsersLoadInProgress extends UserState {}

class UsersLoadSuccess extends UserState {
  final List<CurrentUser> users;

  UsersLoadSuccess( this.users);
}

class UserOperationInProgress extends UserState{}

class UsersLoadFailure extends UserState {}

class UserOperationSuccess extends UserState{}

class UserOperationFailure extends UserState{}

class UserLoggingIn extends UserState{}

class UserLoggedIn extends UserState {

}

class UserLogInFailure extends UserState{}

class UserLoggedOut extends UserState{}

