class CloudAuthProfile {
  const CloudAuthProfile({
    required this.userId,
    required this.username,
    required this.role,
    this.avatarUrl = '',
    this.childName = 'Teman',
    this.gender = 'boy',
    this.themeId = 'default',
    this.stars = 12,
    this.iqraStreak = 0,
    this.progress = const {'membaca': 0, 'angka': 0, 'benda': 0, 'iqra': 0},
    this.iqraMastered = const [],
    this.iqraHistory = const [],
    this.hurfMastered = const [],
    this.angkaMastered = const [],
    this.bendaMastered = const [],
    this.favoriteMaterialIds = const [],
  });

  final String userId;
  final String username;
  final String role;
  final String avatarUrl;
  final String childName;
  final String gender;
  final String themeId;
  final int stars;
  final int iqraStreak;
  final Map<String, int> progress;
  final List<String> iqraMastered;
  final List<String> iqraHistory;
  final List<String> hurfMastered;
  final List<String> angkaMastered;
  final List<String> bendaMastered;
  final List<String> favoriteMaterialIds;
}
