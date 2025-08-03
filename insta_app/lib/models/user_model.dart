class UserModel {
  final int id;
  final String username;
  final String email;
  final String? fullName;
  final String? bio;
  final String? profileImageUrl;
  final bool isVerified;
  final bool isPrivate;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final DateTime? lastLogin;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.fullName,
    this.bio,
    this.profileImageUrl,
    this.isVerified = false,
    this.isPrivate = false,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.lastLogin,
    required this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String?,
      bio: json['bio'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      isPrivate: json['isPrivate'] as bool? ?? false,
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      postsCount: json['postsCount'] as int? ?? 0,
      lastLogin: json['lastLogin'] != null 
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'fullName': fullName,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'isVerified': isVerified,
      'isPrivate': isPrivate,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'postsCount': postsCount,
      'lastLogin': lastLogin?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Copy with method for updating user data
  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? fullName,
    String? bio,
    String? profileImageUrl,
    bool? isVerified,
    bool? isPrivate,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    DateTime? lastLogin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isVerified: isVerified ?? this.isVerified,
      isPrivate: isPrivate ?? this.isPrivate,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Get display name (full name or username)
  String get displayName => fullName?.isNotEmpty == true ? fullName! : username;

  // Get profile image URL with fallback
  String get profileImage => profileImageUrl ?? 'https://via.placeholder.com/150';

  // Check if user has profile image
  bool get hasProfileImage => profileImageUrl?.isNotEmpty == true;

  // Get formatted followers count
  String get formattedFollowersCount {
    if (followersCount >= 1000000) {
      return '${(followersCount / 1000000).toStringAsFixed(1)}M';
    } else if (followersCount >= 1000) {
      return '${(followersCount / 1000).toStringAsFixed(1)}K';
    }
    return followersCount.toString();
  }

  // Get formatted following count
  String get formattedFollowingCount {
    if (followingCount >= 1000000) {
      return '${(followingCount / 1000000).toStringAsFixed(1)}M';
    } else if (followingCount >= 1000) {
      return '${(followingCount / 1000).toStringAsFixed(1)}K';
    }
    return followingCount.toString();
  }

  // Get formatted posts count
  String get formattedPostsCount {
    if (postsCount >= 1000000) {
      return '${(postsCount / 1000000).toStringAsFixed(1)}M';
    } else if (postsCount >= 1000) {
      return '${(postsCount / 1000).toStringAsFixed(1)}K';
    }
    return postsCount.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, email: $email, fullName: $fullName)';
  }
}