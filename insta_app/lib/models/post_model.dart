/// Post Model - Instagram post verilerini temsil eder
class PostModel {
  final String id;
  final String userId;
  final String caption;
  final String imageUrl;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final DateTime createdAt;
  final UserData? user; // Post sahibi kullanıcı bilgileri

  PostModel({
    required this.id,
    required this.userId,
    required this.caption,
    required this.imageUrl,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    required this.createdAt,
    this.user,
  });

  /// JSON'dan PostModel oluştur
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      caption: json['caption']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      likesCount: _parseIntSafely(json['likes_count']),
      commentsCount: _parseIntSafely(json['comments_count']),
      isLiked: json['is_liked'] == true,
      createdAt: _parseDateSafely(json['created_at']),
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
    );
  }

  /// PostModel'i JSON'a dönüştür
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'caption': caption,
      'image_url': imageUrl,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'is_liked': isLiked,
      'created_at': createdAt.toIso8601String(),
      if (user != null) 'user': user!.toJson(),
    };
  }

  /// PostModel kopyalama ve güncelleme
  PostModel copyWith({
    String? id,
    String? userId,
    String? caption,
    String? imageUrl,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    DateTime? createdAt,
    UserData? user,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      caption: caption ?? this.caption,
      imageUrl: imageUrl ?? this.imageUrl,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
    );
  }

  /// Beğeni durumunu toggle et
  PostModel toggleLike() {
    return copyWith(
      isLiked: !isLiked,
      likesCount: isLiked ? likesCount - 1 : likesCount + 1,
    );
  }

  /// Yorum sayısını artır
  PostModel incrementComments() {
    return copyWith(commentsCount: commentsCount + 1);
  }

  /// Yorum sayısını azalt
  PostModel decrementComments() {
    return copyWith(
      commentsCount: commentsCount > 0 ? commentsCount - 1 : 0,
    );
  }

  /// Post yaşını hesapla (örn: "2 saat önce")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 7) {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Şimdi';
    }
  }

  /// Beğeni sayısını formatla (örn: 1.2K)
  String get formattedLikesCount {
    return _formatCount(likesCount);
  }

  /// Yorum sayısını formatla
  String get formattedCommentsCount {
    return _formatCount(commentsCount);
  }

  /// Caption'dan hashtag'leri çıkar
  List<String> get hashtags {
    final RegExp hashtagRegex = RegExp(r'#\w+');
    final matches = hashtagRegex.allMatches(caption);
    return matches.map((match) => match.group(0)!).toList();
  }

  /// Caption'dan mention'ları çıkar
  List<String> get mentions {
    final RegExp mentionRegex = RegExp(r'@\w+');
    final matches = mentionRegex.allMatches(caption);
    return matches.map((match) => match.group(0)!).toList();
  }

  /// Post'un kısa özeti
  String get summary {
    final userDisplayName = user?.displayName ?? 'Bilinmeyen Kullanıcı';
    return '$userDisplayName - $formattedLikesCount beğeni, $formattedCommentsCount yorum';
  }

  @override
  String toString() {
    return 'PostModel(id: $id, userId: $userId, caption: ${caption.length > 50 ? '${caption.substring(0, 50)}...' : caption}, likesCount: $likesCount, isLiked: $isLiked)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  // Helper methods
  static int _parseIntSafely(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static DateTime _parseDateSafely(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  static String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }
}

/// Basit kullanıcı verisi (Post içinde kullanım için)
class UserData {
  final String id;
  final String username;
  final String fullName;
  final String? profilePictureUrl;
  final bool isVerified;

  UserData({
    required this.id,
    required this.username,
    required this.fullName,
    this.profilePictureUrl,
    this.isVerified = false,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      profilePictureUrl: json['profile_picture_url']?.toString(),
      isVerified: json['is_verified'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'profile_picture_url': profilePictureUrl,
      'is_verified': isVerified,
    };
  }

  /// Görüntüleme adı (tam ad varsa onu, yoksa kullanıcı adını kullan)
  String get displayName {
    return fullName.isNotEmpty ? fullName : username;
  }

  /// Profil resmi URL'si (varsayılan resim ile)
  String get profileImageUrl {
    return profilePictureUrl ?? 'https://via.placeholder.com/150x150?text=${username[0].toUpperCase()}';
  }

  @override
  String toString() {
    return 'UserData(id: $id, username: $username, fullName: $fullName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserData && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}