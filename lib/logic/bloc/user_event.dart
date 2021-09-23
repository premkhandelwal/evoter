part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class UserLoaded extends UserEvent {}

class UserAdded extends UserEvent {
  final User user;
  UserAdded({
    required this.user,
  });
}

class UserUpdated extends UserEvent {
  final User user;
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


