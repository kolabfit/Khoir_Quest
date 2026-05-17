class CloudAuthProfile {
  const CloudAuthProfile({
    required this.userId,
    required this.username,
    required this.role,
    this.avatarUrl = '',
  });

  final String userId;
  final String username;
  final String role;
  final String avatarUrl;
}
