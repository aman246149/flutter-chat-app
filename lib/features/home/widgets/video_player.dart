import 'dart:io';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';

import '../../auth/export.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget(
      {Key? key, required this.url, required this.isVideoCached})
      : super(key: key);
  final String url;
  final bool isVideoCached;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late CachedVideoPlayerPlusController _controller;
  final ValueNotifier<bool> _isInitialized = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isPlaying = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    if (widget.isVideoCached) {
      _controller = CachedVideoPlayerPlusController.file(
        File(widget.url),
      );
    } else {
      _controller = CachedVideoPlayerPlusController.networkUrl(
        Uri.parse(widget.url),
        invalidateCacheIfOlderThan: const Duration(days: 1),
      );
    }

    try {
      await _controller.initialize();
      _isInitialized.value = true;
      _controller.addListener(_videoListenerCallback);
    } catch (error) {
      print("Error initializing video player: $error");
    }
  }

  void _videoListenerCallback() {
    _isPlaying.value = _controller.value.isPlaying;
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListenerCallback);
    _controller.dispose();
    _isInitialized.dispose();
    _isPlaying.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isInitialized,
      builder: (context, isInitialized, child) {
        if (!isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }
        return AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                  onTap: _togglePlayPause,
                  child: CachedVideoPlayerPlus(_controller)),
              ValueListenableBuilder<bool>(
                valueListenable: _isPlaying,
                builder: (context, isPlaying, child) {
                  return IgnorePointer(
                    child: Visibility(
                      visible: !isPlaying,
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
