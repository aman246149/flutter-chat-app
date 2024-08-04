import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/bloc/chat/chat_cubit.dart';
import '../../core/bloc/user/user_cubit.dart';
import '../../core/data/model/message.dart';
import '../../core/utils/common_methods.dart';
import '../auth/export.dart';
import 'logic/chat_logic.dart';

@RoutePage()
class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatLogic chatLogic;

  @override
  void initState() {
    super.initState();
    chatLogic = ChatLogic();
    context.read<ChatCubit>().getMessages();
    chatLogic.joinGroup(
        context.read<ChatCubit>().currentlySelectedGroupId ?? "",
        context.read<UserCubit>().user?.name ?? "");
  }

  @override
  void dispose() {
    chatLogic.dispose();
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
            chatLogic.messages.value = state.messages;
            Future.delayed(Duration(milliseconds: 100), () {
              chatLogic.moveToBottom();
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
                valueListenable: chatLogic.messages,
                builder: (context, messages, _) {
                  return ListView.builder(
                    padding: EdgeInsets.only(
                        bottom: kBottomNavigationBarHeight - 28),
                    controller: chatLogic.scrollController,
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
                controller: chatLogic.messageController,
                hintText: "Type a message",
                suffix: InkWell(
                  onTap: () => chatLogic.sendMessage(
                    context.read<ChatCubit>().currentlySelectedGroupId ?? "",
                    context.read<UserCubit>().user?.name ?? "",
                    context.read<ChatCubit>().senderId ?? "",
                    context.read<ChatCubit>().receiverId ?? "",
                  ),
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
