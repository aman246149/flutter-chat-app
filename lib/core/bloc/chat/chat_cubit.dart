import 'package:bloc/bloc.dart';
import 'package:brandzone/core/data/model/message.dart';
import 'package:brandzone/core/data/repository/chat_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../../features/auth/export.dart';
import '../../socket/io.dart';
import '../../utils/common_methods.dart';
import '../user/user_cubit.dart';

part 'chat_state.dart';

@lazySingleton
class ChatCubit extends Cubit<ChatState> {
  ChatCubit(
    this.chatRepository,
  ) : super(ChatInitial());

  String? currentlySelectedGroupId;
  String? receiverId;
  String? senderId;
  String? senderName;
  String? receiverName;

  final ChatRepository chatRepository;

  void createGroup(Map data) async {
    emit(chatLoading());
    try {
      await chatRepository.createGroup(data);
      emit(CreateGroupSuccess());
    } catch (e) {
      emit(chatError(e.toString()));
    }
  }

  void getGroup() async {
    emit(chatLoading());
    try {
      final response = await chatRepository.getGroup();
      emit(GetGroupSuccess(response));
    } catch (e) {
      emit(chatError(e.toString()));
    }
  }

  String generateGroupID(String currentUserId, String otherUserId,
      String currentUserName, String otherUserName) {
    receiverId = otherUserId;
    senderId = currentUserId;

    senderName = currentUserName;
    receiverName = otherUserName;

    currentlySelectedGroupId = (currentUserId.compareTo(otherUserId) < 0)
        ? '$currentUserId-$otherUserId'
        : '$otherUserId-$currentUserId';
    return currentlySelectedGroupId!;
  }

  void getMessages() async {
    emit(chatLoading());
    try {
      List<dynamic> response =
          await chatRepository.getMessages(currentlySelectedGroupId!);
      emit(GetMessagesSuccess(
        response.map((e) {
          return Message.fromJson(e);
        }).toList(),
      ));
    } catch (e) {
      emit(chatError(e.toString()));
    }
  }
}
