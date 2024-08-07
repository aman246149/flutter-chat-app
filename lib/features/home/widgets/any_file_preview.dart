import 'package:brandzone/features/home/logic/chat_logic.dart';

import '../../../core/utils/common_methods.dart';
import '../../auth/export.dart';
import 'video_player.dart';

class AnyFileView extends StatelessWidget {
  const AnyFileView({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    switch (getExtensionType(url)) {
      case MessageType.image:
        return Image.network(url,);

      case MessageType.video:
        return VideoPlayerWidget(url: url);

      case MessageType.text:
        return Text(url);
      default:
        return const Text('Unsupported file type');
    }
  }
}
