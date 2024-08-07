import 'dart:io';

import 'package:brandzone/core/utils/uploadfiletos3.dart';
import 'package:file_picker/file_picker.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../../core/data/model/message.dart';
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

  ChatLogic() {
    socketIO = SocketIO();
    if (!socketIO.socket.connected) {
      socketIO.socket.connect();
    }
    setupSocketListeners();
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
      {MessageType typeParms = MessageType.text}) {
    if (messageController.text.isNotEmpty) {
      logger.d("Sending message: ${messageController.text}");

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

      messageController.clear();
    }
  }

  void moveToBottom() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + kBottomNavigationBarHeight,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<String?> openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      //call s3 upload function
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
      print('Presigned URL: $presignedUrl');
      await uploadFileToS3(File(result.files.single.path!), presignedUrl);
      return objectKey;
    }
    return null;
  }

  void dispose() {
    _isActive = false;
    messageController.dispose();
    socketIO.socket.disconnect();
    scrollController.dispose();
  }
}
