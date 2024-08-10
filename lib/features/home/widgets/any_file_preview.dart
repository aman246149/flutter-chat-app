import 'dart:io';

import 'package:brandzone/features/home/logic/chat_logic.dart';

import '../../../core/utils/common_methods.dart';
import '../../auth/export.dart';
import 'video_player.dart';

class AnyFileView extends StatefulWidget {
  const AnyFileView(
      {super.key, required this.url, required this.storedInLocalDb});
  final String url;
  final bool storedInLocalDb;

  @override
  State<AnyFileView> createState() => _AnyFileViewState();
}

class _AnyFileViewState extends State<AnyFileView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    switch (getExtensionType(widget.url)) {
      case MessageType.image:
        return widget.storedInLocalDb
            ? Image.file(
                File(widget.url),
              )
            : Image.network(
                widget.url,
              );

      case MessageType.video:
        return VideoPlayerWidget(
          url: widget.url,
          isVideoCached: widget.storedInLocalDb,
        );

      case MessageType.text:
        return Text(widget.url);
      default:
        return const Text('Unsupported file type');
    }
  }

  @override
  bool get wantKeepAlive => true;
}
