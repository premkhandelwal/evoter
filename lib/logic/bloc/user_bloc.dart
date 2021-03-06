import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:evoter/logic/data/apiProvider.dart';
import 'package:evoter/models/user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final ApiProvider apiProvider;
  UserBloc(
    this.apiProvider,
  ) : super(UsersLoadInProgress());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is UserLoaded) {
      yield* _mapUserLoadedToState();
    } else if (event is UserAdded) {
      yield* _mapUserAddedToState(event);
    } else if (event is UserUpdated) {
      yield* _mapUserUpdatedToState(event);
    } else if (event is UserDeleted) {
      yield* _mapUserDeletedToState(event);
    } else if (event is SignInRequested) {
      yield* _mapLoginToState(event);
    } else if (event is LogOutRequested) {
      yield* _mapLogoutToState();
    }
  }

  Stream<UserState> _mapLoginToState(SignInRequested event) async* {
    yield UserLoggingIn();
    try {
      bool loggedIn = await apiProvider.login(event.mobileNo, event.password);
      print(loggedIn);
      if (loggedIn) {
        yield UserLoggedIn();
      } else {
        yield UserLogInFailure();
      }
    } catch (e) {
      yield UserLogInFailure();
    }
  }

  Stream<UserState> _mapUserLoadedToState() async* {
    yield UsersLoadInProgress();
    
    try {
      final users = await this.apiProvider.fetchAllUsers();
      yield UsersLoadSuccess(
        users,
      );
    } catch (e) {
      print(e);
      yield UsersLoadFailure();
    }
  }

  Stream<UserState> _mapUserAddedToState(UserAdded event) async* {
    yield UserOperationInProgress();

    try {
      final users = await this.apiProvider.addUser(event.user);
      yield users ? UserOperationSuccess() : UserOperationFailure();
    } catch (_) {
      yield UserOperationFailure();
    }
  }

  Stream<UserState> _mapUserUpdatedToState(UserUpdated event) async* {
    yield UserOperationInProgress();
    try {
      final users = await this.apiProvider.updateUser(event.user);
      yield users ? UserOperationSuccess() : UserOperationFailure();
    } catch (_) {
      yield UserOperationFailure();
    }
  }

  Stream<UserState> _mapUserDeletedToState(UserDeleted event) async* {
    try {
      final users = await this.apiProvider.deleteUser(event.userCode);
      yield users ? UserOperationSuccess() : UserOperationFailure();
    } catch (_) {
      yield UserOperationFailure();
    }
  }

  Stream<UserState> _mapLogoutToState() async* {
    await apiProvider.logOut();
    yield UserLoggedOut();
  }
}
