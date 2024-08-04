part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class GetUserProfile extends UserState {
  final UserModel? user;

  GetUserProfile(this.user);

  @override
  List<Object> get props => [user ?? "No User"];
}

class UserError extends UserState {
  final String message;

  UserError(this.message);

  @override
  List<Object> get props => [message];
}

class GetAllUsersSuccessState extends UserState {
  final List<UserModel> users;

  const GetAllUsersSuccessState(this.users);

  @override
  List<Object> get props => [users];
}
