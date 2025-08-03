import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/post_model.dart';

/// Instagram post kartı widget'ı
class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSave;

  const PostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header (kullanıcı bilgileri)
          _buildPostHeader(context),
          
          // Post image
          _buildPostImage(),
          
          // Post actions (like, comment, share)
          _buildPostActions(context),
          
          // Likes count
          _buildLikesCount(context),
          
          // Caption
          _buildCaption(context),
          
          // Comments preview
          _buildCommentsPreview(context),
          
          // Time ago
          _buildTimeAgo(context),
          
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  /// Post header - kullanıcı profil resmi, adı ve menü
  Widget _buildPostHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Profile picture
          CircleAvatar(
            radius: 16,
            backgroundImage: post.user?.profilePictureUrl != null
                ? CachedNetworkImageProvider(post.user!.profileImageUrl)
                : null,
            child: post.user?.profilePictureUrl == null
                ? Text(
                    post.user?.username.isNotEmpty == true
                        ? post.user!.username[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          
          // Username and verification
          Expanded(
            child: Row(
              children: [
                Text(
                  post.user?.username ?? 'unknown_user',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (post.user?.isVerified == true) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.verified,
                    color: Colors.blue,
                    size: 16,
                  ),
                ],
              ],
            ),
          ),
          
          // More options menu
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showPostOptions(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  /// Post image
  Widget _buildPostImage() {
    return AspectRatio(
      aspectRatio: 1.0, // Square aspect ratio like Instagram
      child: CachedNetworkImage(
        imageUrl: post.imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[200],
          child: const Center(
            child: Icon(
              Icons.broken_image,
              size: 50,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  /// Post actions - like, comment, share, save
  Widget _buildPostActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Like button
          GestureDetector(
            onTap: onLike,
            child: Icon(
              post.isLiked ? Icons.favorite : Icons.favorite_border,
              color: post.isLiked ? Colors.red : Colors.black,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          
          // Comment button
          GestureDetector(
            onTap: onComment,
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          
          // Share button
          GestureDetector(
            onTap: onShare,
            child: const Icon(
              Icons.send,
              size: 28,
            ),
          ),
          
          const Spacer(),
          
          // Save button
          GestureDetector(
            onTap: onSave,
            child: const Icon(
              Icons.bookmark_border,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  /// Likes count
  Widget _buildLikesCount(BuildContext context) {
    if (post.likesCount == 0) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        '${post.formattedLikesCount} beğeni',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  /// Caption with hashtags and mentions
  Widget _buildCaption(BuildContext context) {
    if (post.caption.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          children: [
            // Username
            TextSpan(
              text: '${post.user?.username ?? 'unknown_user'} ',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            // Caption with hashtags and mentions highlighted
            ..._buildCaptionSpans(post.caption),
          ],
        ),
      ),
    );
  }

  /// Build caption spans with hashtag and mention highlighting
  List<TextSpan> _buildCaptionSpans(String caption) {
    final List<TextSpan> spans = [];
    final RegExp pattern = RegExp(r'(#\w+|@\w+)');
    final matches = pattern.allMatches(caption);
    
    int lastEnd = 0;
    
    for (final match in matches) {
      // Add text before the match
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: caption.substring(lastEnd, match.start),
        ));
      }
      
      // Add the highlighted match
      final matchText = match.group(0)!;
      spans.add(TextSpan(
        text: matchText,
        style: TextStyle(
          color: matchText.startsWith('#') ? Colors.blue : Colors.blue,
          fontWeight: FontWeight.w500,
        ),
      ));
      
      lastEnd = match.end;
    }
    
    // Add remaining text
    if (lastEnd < caption.length) {
      spans.add(TextSpan(
        text: caption.substring(lastEnd),
      ));
    }
    
    return spans;
  }

  /// Comments preview
  Widget _buildCommentsPreview(BuildContext context) {
    if (post.commentsCount == 0) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: GestureDetector(
        onTap: onComment,
        child: Text(
          post.commentsCount == 1
              ? '1 yorumu görüntüle'
              : '${post.formattedCommentsCount} yorumu görüntüle',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  /// Time ago
  Widget _buildTimeAgo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Text(
        post.timeAgo,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
    );
  }

  /// Show post options bottom sheet
  void _showPostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Bağlantıyı kopyala'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bağlantı kopyalandı'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Paylaş'),
              onTap: () {
                Navigator.pop(context);
                if (onShare != null) onShare!();
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_outlined),
              title: const Text('Bildir'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Gönderi bildirildi'),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}