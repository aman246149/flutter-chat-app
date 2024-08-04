import 'package:brandzone/core/bloc/auth/auth_bloc.dart';
import 'package:brandzone/core/bloc/chat/chat_cubit.dart';
import 'package:brandzone/core/data/model/message.dart';
import 'package:brandzone/core/utils/common_methods.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../../core/bloc/user/user_cubit.dart';
import '../../core/socket/io.dart';
import '../../main.dart';
import '../auth/export.dart';

@RoutePage()
class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late SocketIO socketIO;
  TextEditingController messageController = TextEditingController();
  ValueNotifier<List<Message>> messages = ValueNotifier<List<Message>>([]);
  bool _isActive = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().getMessages();
    socketIO = SocketIO();
    if (!socketIO.socket.connected) {
      socketIO.socket.connect();
    }
    setupSocketListeners();
    joinGroup();
  }

  void setupSocketListeners() {
    socketIO.socket.onConnect((_) {
      logger.d('Connected to server');
    });

    socketIO.socket.onConnectError((err) => logger.d('Connect error: $err'));
    socketIO.socket.onDisconnect((_) => logger.d('Disconnected from server'));
    socketIO.socket.onError((error) => logger.d('Error: $error'));
    socketIO.socket
        .on('connect_error', (error) => logger.d('Connect error: $error'));

    socketIO.socket.onAny((event, data) {
      logger.d("Received event: $event, data: $data");
    });

    socketIO.socket.on("newMessage", (data) {
      logger.d("Received newMessage event. Data: $data");
      if (_isActive && data is Map<String, dynamic>) {
        messages.value = [...messages.value, Message.fromJson(data)];
      } else {
        logger.d("Widget is disposed or received data is not a Map: $data");
      }
      moveToBottom();
    });

    socketIO.socket.on("userJoined", (data) {
      logger.d("User joined: $data");
      if (_isActive && data is String) {
        showSnackbar(context, data);
      }
    });
  }

  void joinGroup() {
    logger.d(
        "Joining group: ${context.read<ChatCubit>().currentlySelectedGroupId}");
    socketIO.socket.emit("joinGroup", {
      "groupName": context.read<ChatCubit>().currentlySelectedGroupId,
      "userName": context.read<UserCubit>().user?.name ?? ""
    });
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      logger.d("Sending message: ${messageController.text}");

      socketIO.socket.emit("groupMessage", {
        "groupName": context.read<ChatCubit>().currentlySelectedGroupId,
        "message": messageController.text,
        "userName": context.read<UserCubit>().user?.name ?? "",
        "senderId": context.read<ChatCubit>().senderId,
        "receiverId": context.read<ChatCubit>().receiverId,
      });

      messageController.clear();
    }
  }

  void moveToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + kBottomNavigationBarHeight,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _isActive = false;
    messageController.dispose();
    socketIO.socket.disconnect();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat with ${context.read<ChatCubit>().receiverName}",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
        ),
      ),
      body: BlocListener<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is chatLoading) {
            showOverlayLoader(context);
          } else if (state is GetMessagesSuccess) {
            hideOverlayLoader(context);
            messages.value = state.messages;
            Future.delayed(Duration(milliseconds: 100), () {
              moveToBottom();
            });
          } else if (state is chatError) {
            hideOverlayLoader(context);
            showErrorSnackbar(context, state.message);
          }
        },
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder<List<Message>>(
                valueListenable: messages,
                builder: (context, messages, _) {
                  return ListView.builder(
                    padding: EdgeInsets.only(
                        bottom: kBottomNavigationBarHeight - 28),
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isCurrentUser =
                          message.sender == context.read<ChatCubit>().senderId;

                      return Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isCurrentUser
                                ? Colors.blue[100]
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: isCurrentUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.message ?? '',
                                style: TextStyle(
                                  color: isCurrentUser
                                      ? Colors.black
                                      : Colors.black,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                getUserName(message.sender!),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                timeAgo(message.timestamp ??
                                    DateTime.now().microsecondsSinceEpoch),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Row(
          children: [
            Expanded(
              child: BorderedTextFormField(
                controller: messageController,
                hintText: "Type a message",
                suffix: InkWell(
                  onTap: sendMessage,
                  child: Icon(
                    Icons.send,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getUserName(String id) {
    if (context.read<ChatCubit>().senderId == id) {
      return context.read<ChatCubit>().senderName ?? "";
    } else {
      return context.read<ChatCubit>().receiverName ?? "";
    }
  }
}
