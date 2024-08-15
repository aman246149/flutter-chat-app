// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:isolate';

import 'package:brandzone/core/bloc/chat/chat_cubit.dart';
import 'package:brandzone/core/data/db/chat_db.dart';
import 'package:brandzone/core/utils/common_methods.dart';
import 'package:brandzone/core/utils/uploadfiletos3.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/data/model/message.dart';
import '../../../core/routes/router.dart';
import '../../../core/socket/io.dart';
import '../../../env.dart';
import '../../../main.dart';
import '../../auth/export.dart';

enum MessageType { text, image, video, audio, file }

class ChatLogic {
  late SocketIO socketIO;
  TextEditingController messageController = TextEditingController();
  ValueNotifier<List<Message>> messages = ValueNotifier<List<Message>>([]);
  bool _isActive = true;
  final ScrollController scrollController = ScrollController();
  ValueNotifier<bool> isUploading = ValueNotifier<bool>(false);
  ChatDatabase chatDatabase = ChatDatabase();
  late BuildContext context;
  ValueNotifier<bool> isDownloadingFile = ValueNotifier<bool>(false);

  ChatLogic() {
    socketIO = SocketIO();
    if (!socketIO.socket.connected) {
      socketIO.socket.connect();
    }
    setupSocketListeners();
    context = GetIt.I<AppRouter>().navigatorKey.currentContext!;
    addGroupToDb();
    getMessagesFromDb();
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
        Message newIncomingMessage = Message.fromJson(data);
        messages.value = [...messages.value, newIncomingMessage];
        addMessagesToDb(
            groupId: context.read<ChatCubit>().currentlySelectedGroupId!,
            senderId: newIncomingMessage.sender!,
            receiverId: newIncomingMessage.receiver!,
            typeOfMessage: newIncomingMessage.type!,
            message: newIncomingMessage.message!,
            filePath: null);
      } else {
        logger.d("Widget is disposed or received data is not a Map: $data");
      }
      moveToBottom();
    });

    socketIO.socket.on("userJoined", (data) {
      logger.d("User joined: $data");
      // Note: We'll need to handle showing the snackbar in the UI
    });
  }

  void joinGroup(String groupId, String userName) {
    logger.d("Joining group: $groupId");
    socketIO.socket
        .emit("joinGroup", {"groupName": groupId, "userName": userName});
  }

  void sendMessage(
      String groupId, String userName, String senderId, String receiverId,
      {MessageType typeParms = MessageType.text, String? filePath}) {
    if (messageController.text.isNotEmpty) {
      String type = MessageType.text.name;
      switch (typeParms) {
        case MessageType.text:
          type = MessageType.text.name;
          break;
        case MessageType.image:
          type = MessageType.image.name;
          break;
        case MessageType.video:
          type = MessageType.video.name;
          break;
        case MessageType.audio:
          type = MessageType.audio.name;
          break;
        case MessageType.file:
          type = MessageType.file.name;
          break;
        default:
      }

      socketIO.socket.emit("groupMessage", {
        "groupName": groupId,
        "message": messageController.text,
        "userName": userName,
        "senderId": senderId,
        "receiverId": receiverId,
        "type": type
      });

      messages.value = [
        ...messages.value,
        Message(
            message: messageController.text,
            sender: senderId,
            receiver: receiverId,
            type: type,
            timestamp: DateTime.now().millisecondsSinceEpoch)
      ];

      addMessagesToDb(
          message: messageController.text,
          groupId: groupId,
          senderId: senderId,
          receiverId: receiverId,
          typeOfMessage: type,
          filePath: filePath);
      messageController.clear();
    }

    moveToBottom();
  }

  void moveToBottom() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(
      scrollController.position.maxScrollExtent +
          kBottomNavigationBarHeight +
          100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<UploadedFileData?> openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      if (result.files.single.size > 50000000) {
        showErrorSnackbar(context, "File size should be less than 50 MB");
        return null;
      }
      File file = File(result
          .files.single.path!); // Ensure the file path includes the extension
      String objectKey = file.path
          .split('/')
          .last; // Ensure the object key includes the extension
      final presignedUrl = generatePresignedUrl(
        Env.accessKey,
        Env.secretKey,
        Env.region,
        Env.bucketName,
        'assets/$objectKey',
        3600,
      );
      isUploading.value = true;
      await Isolate.run(
          () => uploadFileToS3(File(result.files.single.path!), presignedUrl));
      isUploading.value = false;
      return UploadedFileData(objectKey: objectKey, filePath: file.path);
    }
    return null;
  }

  void addGroupToDb() async {
    Map<String, dynamic> getGroupById = await chatDatabase
        .getGroupById(context.read<ChatCubit>().currentlySelectedGroupId!);
    if (getGroupById.isEmpty) {
      await chatDatabase.insertGroup({
        "groupId": context.read<ChatCubit>().currentlySelectedGroupId,
        "name": ""
      });
    }
  }

  void addMessagesToDb(
      {required String groupId,
      required String senderId,
      required String receiverId,
      required String typeOfMessage,
      required String message,
      String? filePath}) async {
    String? savePathUrl;
    if (typeOfMessage != MessageType.text.name && filePath == null) {
      isDownloadingFile.value = true;
      savePathUrl = await saveFileFromUrl(
        MessageType.values.firstWhere((e) => e.name == typeOfMessage),
        message,
        message.split('/').last,
      );
      isDownloadingFile.value = false;
    }

    if (filePath != null) {
      savePathUrl = filePath;
    }

    chatDatabase.insertMessage({
      "message": savePathUrl ?? message,
      "sender": senderId,
      "receiverStatus": "sent",
      "senderStatus": "sent",
      "receiver": receiverId,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "type": typeOfMessage,
      "groupId": groupId,
      "storedInLocalDb": savePathUrl != null ? 1 : 0
    });
  }

  void getMessagesFromDb() async {
    List<Map<String, dynamic>> messagesFromDb = await chatDatabase
        .getMessages(context.read<ChatCubit>().currentlySelectedGroupId!);
    List<Message> messagesList =
        messagesFromDb.map((message) => Message.fromJson(message)).toList();
    messages.value = messagesList;
  }

  void dispose() {
    _isActive = false;
    messageController.dispose();
    socketIO.socket.disconnect();
    scrollController.dispose();
  }
}

class UploadedFileData {
  String objectKey;
  String filePath;

  UploadedFileData({required this.objectKey, required this.filePath});
}
