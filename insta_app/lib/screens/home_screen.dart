import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/api_service_wrapper.dart';
import '../widgets/post_card.dart';

/// Ana sayfa - Instagram feed'ini gösterir
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PostModel> _posts = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  int _currentPage = 1;
  bool _hasMorePosts = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadFeed();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Feed verilerini yükle
  Future<void> _loadFeed({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() {
        _currentPage = 1;
        _hasMorePosts = true;
        _isLoading = true;
        _hasError = false;
      });
    }

    try {
      final result = await ApiServiceWrapper.getFeed(
        page: _currentPage,
        limit: 10,
      );

      if (result['success'] == true) {
        final data = result['data'];
        final List<dynamic> postsJson = data['posts'] ?? [];
        final List<PostModel> newPosts = postsJson
            .map((json) => PostModel.fromJson(json))
            .toList();

        setState(() {
          if (isRefresh) {
            _posts = newPosts;
          } else {
            _posts.addAll(newPosts);
          }
          _hasMorePosts = data['has_more'] ?? false;
          _isLoading = false;
          _hasError = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _errorMessage = 'Feed yüklenemedi';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Bağlantı hatası: $e';
        _isLoading = false;
      });
    }
  }

  /// Scroll listener - sayfa sonuna gelince yeni postlar yükle
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMorePosts) {
      _loadMorePosts();
    }
  }

  /// Daha fazla post yükle
  Future<void> _loadMorePosts() async {
    setState(() {
      _currentPage++;
      _isLoading = true;
    });
    await _loadFeed();
  }

  /// Pull-to-refresh
  Future<void> _onRefresh() async {
    await _loadFeed(isRefresh: true);
  }

  /// Post beğenme/beğenmeme
  Future<void> _toggleLike(PostModel post) async {
    try {
      // Optimistic update
      final updatedPost = post.toggleLike();
      final postIndex = _posts.indexWhere((p) => p.id == post.id);
      if (postIndex != -1) {
        setState(() {
          _posts[postIndex] = updatedPost;
        });
      }

      // API çağrısı
      final result = await ApiServiceWrapper.toggleLike(post.id);
      
      if (result['success'] != true) {
        // Hata durumunda geri al
        setState(() {
          _posts[postIndex] = post;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Beğeni işlemi başarısız'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Hata durumunda geri al
      final postIndex = _posts.indexWhere((p) => p.id == post.id);
      if (postIndex != -1) {
        setState(() {
          _posts[postIndex] = post;
        });
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Instagram',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 28,
                fontWeight: FontWeight.normal,
              ),
            ),
            const Spacer(),
            // API Status indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ApiServiceWrapper.isUsingMockData 
                    ? Colors.orange.withOpacity(0.2)
                    : Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                ApiServiceWrapper.isUsingMockData ? '🎭 Mock' : '🌐 Live',
                style: TextStyle(
                  fontSize: 12,
                  color: ApiServiceWrapper.isUsingMockData 
                      ? Colors.orange[700]
                      : Colors.green[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // Notifications screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              // Messages screen
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _posts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Feed yükleniyor...'),
          ],
        ),
      );
    }

    if (_hasError && _posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadFeed(isRefresh: true),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    }

    if (_posts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Henüz gönderi yok',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Takip ettiğiniz kişilerin gönderileri burada görünecek',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _posts.length + (_hasMorePosts ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _posts.length) {
            // Loading indicator for pagination
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final post = _posts[index];
          return PostCard(
            post: post,
            onLike: () => _toggleLike(post),
            onComment: () {
              // Navigate to comments screen
              _showCommentsBottomSheet(post);
            },
            onShare: () {
              // Share functionality
              _sharePost(post);
            },
          );
        },
      ),
    );
  }

  /// Yorumlar bottom sheet'ini göster
  void _showCommentsBottomSheet(PostModel post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Yorumlar',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Yorumlar yakında eklenecek...',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Post paylaşma
  void _sharePost(PostModel post) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Paylaşım özelliği yakında eklenecek'),
      ),
    );
  }
}