part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class chatLoading extends ChatState {}

class chatError extends ChatState {
  final String message;

  chatError(this.message);
}

class CreateGroupSuccess extends ChatState {
  CreateGroupSuccess();
}

class GetGroupSuccess extends ChatState {
  final dynamic groups;

  GetGroupSuccess(this.groups);
}

class GetMessagesSuccess extends ChatState {
  final List<Message> messages;

  GetMessagesSuccess(this.messages);
}
