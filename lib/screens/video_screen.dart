import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  final List<Map<String, String>> videos = const [
    {
      'title': 'Winter Girl',
      'id': 'Un62qURWp2U',
      'thumbnail': 'https://img.youtube.com/vi/nPt8bK2gbaU/0.jpg',
    },
    {
      'title': 'Qua trinh dien phan',
      'id': 'ZvDF7_wksX8',
      'thumbnail': 'https://img.youtube.com/vi/gQDByCdjUXw/0.jpg',
    },
    {
      'title': 'Real Madrid',
      'id': 'xfeBelVzEHQ',
      'thumbnail': 'https://img.youtube.com/vi/iLnmTe5Q2Qw/0.jpg',
    },
  ];

  late PageController _pageController;
  List<YoutubePlayerController> _controllers = [];

  final Set<int> _likedVideos = {}; // Trạng thái video đã like
  final Map<int, List<String>> _comments = {}; // Danh sách comment theo video

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Khởi tạo controllers cho mỗi video
    _controllers = videos.map((video) {
      return YoutubePlayerController(
        initialVideoId: video['id']!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: true,
          loop: true,
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Shorts',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: videos.length,
        onPageChanged: (index) {
          // Dừng video hiện tại khi chuyển trang
          for (var controller in _controllers) {
            controller.pause();
          }
          // Phát video mới
          _controllers[index].play();
        },
        itemBuilder: (context, index) {
          return Container(
            color: Colors.black,
            child: Stack(
              fit: StackFit.expand,
              children: [
                YoutubePlayerBuilder(
                  player: YoutubePlayer(
                    controller: _controllers[index],
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.red,
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.red,
                      handleColor: Colors.redAccent,
                    ),
                    aspectRatio: 9 / 16, // Tỷ lệ dọc cho Shorts
                  ),
                  builder: (context, player) {
                    return player;
                  },
                ),
                // Overlay controls
                Positioned(
                  right: 16,
                  bottom: 100,
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          _likedVideos.contains(index)
                              ? Icons.thumb_up
                              : Icons.thumb_up_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_likedVideos.contains(index)) {
                              _likedVideos.remove(index);
                            } else {
                              _likedVideos.add(index);
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.comment, color: Colors.white),
                        onPressed: () {
                          _showCommentsBottomSheet(context, index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Video shared!'),
                          ));
                        },
                      ),
                    ],
                  ),
                ),
                // Video title and description
                Positioned(
                  left: 16,
                  bottom: 50,
                  right: 80,
                  child: Text(
                    videos[index]['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context, int videoIndex) {
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Hiển thị danh sách comment
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _comments[videoIndex]?.length ?? 0,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(_comments[videoIndex]![index]),
                    );
                  },
                ),
              ),
              // Input để thêm comment mới
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: const InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        setState(() {
                          if (_comments[videoIndex] == null) {
                            _comments[videoIndex] = [];
                          }
                          _comments[videoIndex]!.add(commentController.text);
                          commentController.clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
