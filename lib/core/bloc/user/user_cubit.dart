import 'package:bloc/bloc.dart';
import 'package:brandzone/core/data/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../data/model/user.dart';

part 'user_state.dart';

@lazySingleton
class UserCubit extends Cubit<UserState> {
  UserCubit({required this.userRepository}) : super(UserInitial());

  final UserRepository userRepository;
  UserModel? user;

  void getUser() async {
    try {
      var response = await userRepository.getUser();
      user = UserModel.fromJson(response);
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void getAllUsers() async {
    emit(UserLoading());
    try {
      final response = await userRepository.getAllUsers();
      List<dynamic> list = response as List<dynamic>;
      emit(GetAllUsersSuccessState(
          list.map((e) => UserModel.fromJson(e)).toList()));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
