class Contact {
  final String id;
  final String name;
  final String? profilePicUrl;
  final String pubkey;
  final String? nickname;
  final DateTime createdAt;
  final DateTime? lastModified;

  Contact({
    required this.id,
    required this.name,
    this.profilePicUrl,
    required this.pubkey,
    this.nickname,
    DateTime? createdAt,
    this.lastModified,
  }) : createdAt = createdAt ?? DateTime.now();

  // Create a copy with modified fields
  Contact copyWith({
    String? id,
    String? name,
    String? profilePicUrl,
    String? pubkey,
    String? nickname,
    DateTime? createdAt,
    DateTime? lastModified,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      pubkey: pubkey ?? this.pubkey,
      nickname: nickname ?? this.nickname,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profilePicUrl': profilePicUrl,
      'pubkey': pubkey,
      'nickname': nickname,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified?.toIso8601String(),
    };
  }

  // Create from JSON
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String,
      name: json['name'] as String,
      profilePicUrl: json['profilePicUrl'] as String?,
      pubkey: json['pubkey'] as String,
      nickname: json['nickname'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: json['lastModified'] != null
          ? DateTime.parse(json['lastModified'] as String)
          : null,
    );
  }

  // Display name (nickname if available, otherwise name)
  String get displayName => nickname?.isNotEmpty == true ? nickname! : name;

  @override
  String toString() {
    return 'Contact(id: $id, name: $name, nickname: $nickname, pubkey: $pubkey)';
  }
}