import 'package:brandzone/features/home/logic/chat_logic.dart';

import '../../../core/utils/common_methods.dart';
import '../../auth/export.dart';
import 'video_player.dart';

class AnyFileView extends StatefulWidget {
  const AnyFileView({super.key, required this.url});
  final String url;

  @override
  State<AnyFileView> createState() => _AnyFileViewState();
}

class _AnyFileViewState extends State<AnyFileView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("Rebuilding");
    switch (getExtensionType(widget.url)) {
      case MessageType.image:
        return Image.network(
          widget.url,
        );

      case MessageType.video:
        return VideoPlayerWidget(url: widget.url);

      case MessageType.text:
        return Text(widget.url);
      default:
        return const Text('Unsupported file type');
    }
  }

  @override
  bool get wantKeepAlive => true;
}
