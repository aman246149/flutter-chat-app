import 'package:brandzone/core/utils/uploadfiletos3.dart';
import 'package:brandzone/env.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/bloc/chat/chat_cubit.dart';
import '../../core/bloc/user/user_cubit.dart';
import '../../core/data/model/message.dart';
import '../../core/utils/common_methods.dart';
import '../auth/export.dart';
import 'logic/chat_logic.dart';
import 'widgets/any_file_preview.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  late ChatLogic chatLogic;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    chatLogic = ChatLogic();
    // context.read<ChatCubit>().getMessages();
    chatLogic.joinGroup(
        context.read<ChatCubit>().currentlySelectedGroupId ?? "",
        context.read<UserCubit>().user?.name ?? "");
  }

  @override
  void didChangeMetrics() {
    final value = WidgetsBinding
        .instance.platformDispatcher.views.first.viewInsets.bottom;
    if (value != 0.0) {
      chatLogic.moveToBottom();
    }
  }

  @override
  void dispose() {
    chatLogic.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void sendMessage(MessageType messageType, {String? filePath}) {
    chatLogic.sendMessage(
        context.read<ChatCubit>().currentlySelectedGroupId ?? "",
        context.read<UserCubit>().user?.name ?? "",
        context.read<ChatCubit>().senderId ?? "",
        context.read<ChatCubit>().receiverId ?? "",
        typeParms: messageType,
        filePath: filePath);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      body: Stack(
        children: [
          BlocListener<ChatCubit, ChatState>(
            listener: (context, state) {
              if (state is chatLoading) {
                showOverlayLoader(context);
              } else if (state is GetMessagesSuccess) {
                hideOverlayLoader(context);
                chatLogic.messages.value = state.messages;
                Future.delayed(const Duration(milliseconds: 300), () {
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
                        padding: const EdgeInsets.only(
                            bottom: kBottomNavigationBarHeight - 28),
                        controller: chatLogic.scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isCurrentUser = message.sender ==
                              context.read<ChatCubit>().senderId;

                          return Align(
                            alignment: isCurrentUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              padding: const EdgeInsets.all(10),
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
                                  AnyFileView(
                                    url: message.message ?? "",
                                    storedInLocalDb: message.storedInLocalDb ==
                                        1, // 1 means true, 0 means false
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    getUserName(message.sender!),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
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
          ValueListenableBuilder(
              valueListenable: chatLogic.isUploading,
              builder: (context, value, child) {
                return Visibility(
                  visible: value,
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Lottie.asset('assets/images/downloadlottie.json',
                          height: 300,
                          width: 300,
                          fit: BoxFit.cover,
                          frameRate: FrameRate.max)),
                );
              })
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: BorderedTextFormField(
                controller: chatLogic.messageController,
                hintText: "Type a message",
                noBorder: true,
              ),
            ),
            const Hspace(20),
            InkWell(
              onTap: () async {
                UploadedFileData? uploadedFileData =
                    await chatLogic.openFilePicker();
                if (uploadedFileData == null) return;
                String downloadUrl = generateStaticS3Url(
                  Env.region,
                  Env.bucketName,
                  'assets/${uploadedFileData.objectKey}',
                );
                chatLogic.messageController.text = downloadUrl;
                sendMessage(getMessageTypeByUrl(downloadUrl),
                    filePath: uploadedFileData.filePath);
              },
              child: const Icon(
                Icons.attach_file,
                color: AppColors.primary,
              ),
            ),
            const Hspace(20),
            InkWell(
              onTap: () => sendMessage(MessageType.text),
              child: const Icon(
                Icons.send,
                color: AppColors.primary,
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

  @override
  bool get wantKeepAlive => true;
}

MessageType getMessageTypeByUrl(String url) {
  if (getExtensionType(url) == MessageType.text) {
    return MessageType.text;
  } else if (getExtensionType(url) == MessageType.image) {
    return MessageType.image;
  } else if (getExtensionType(url) == MessageType.video) {
    return MessageType.video;
  } else if (getExtensionType(url) == MessageType.audio) {
    return MessageType.audio;
  } else {
    return MessageType.file;
  }
}
