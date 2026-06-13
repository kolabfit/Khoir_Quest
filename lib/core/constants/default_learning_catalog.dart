import '../utils/media_source_helper.dart';

class LearningCategories {
  const LearningCategories._();

  static const huruf = 'huruf';
  static const angka = 'angka';
  static const benda = 'benda';
  static const iqra = 'iqra';
  static const lagu = 'lagu';
  static const modeSeru = 'mode_seru';

  static const appStateHuruf = 'membaca';

  static const progressCategories = [huruf, angka, benda, iqra, modeSeru];

  static String normalizeProgressKey(String key) {
    return key == appStateHuruf ? huruf : key;
  }

  static String appStateKey(String key) {
    return key == huruf ? appStateHuruf : key;
  }
}

class DefaultLearningCatalog {
  const DefaultLearningCatalog._();

  static const hurufPlaceholderAsset = 'assets/images/Logo_membaca.png';
  static const angkaPlaceholderAsset = 'assets/images/Logo_123.png';
  static const bendaPlaceholderAsset = 'assets/images/Logo_Benda.png';
  static const iqraPlaceholderAsset = 'assets/images/Logo_iqra.png';
  static const laguPlaceholderAsset = 'assets/images/lagu_anak.png';
  static const avatarBoyAsset = 'assets/images/profil_lakilaki.png';
  static const avatarGirlAsset = 'assets/images/profil_perempuan.png';

  static const bendaSeed = <Map<String, String>>[
    {'title': 'Mobil', 'subcategory': 'kendaraan'},
    {'title': 'Rumah', 'subcategory': 'benda'},
    {'title': 'Sepeda', 'subcategory': 'kendaraan'},
    {'title': 'Meja', 'subcategory': 'alat sekolah'},
    {'title': 'Kursi', 'subcategory': 'alat sekolah'},
    {'title': 'Buku', 'subcategory': 'alat sekolah'},
    {'title': 'Pensil', 'subcategory': 'alat sekolah'},
    {'title': 'Tas', 'subcategory': 'alat sekolah'},
  ];

  static const hurufSeed = <String>[
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  static const angkaSeed = <String>[
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  static const hurufExamples = <String, String>{
    'A': 'Apel',
    'B': 'Bola',
    'C': 'Cicak',
    'D': 'Domba',
    'E': 'Elang',
    'F': 'Foto',
    'G': 'Gajah',
    'H': 'Harimau',
    'I': 'Ikan',
    'J': 'Jeruk',
    'K': 'Kucing',
    'L': 'Lampu',
    'M': 'Mobil',
    'N': 'Nanas',
    'O': 'Obeng',
    'P': 'Pisang',
    'Q': 'Quran',
    'R': 'Rumah',
    'S': 'Sepeda',
    'T': 'Tomat',
    'U': 'Ular',
    'V': 'Vas',
    'W': 'Wortel',
    'X': 'Xylophone',
    'Y': 'Yo-yo',
    'Z': 'Zebra',
  };

  static const angkaLabels = <String, String>{
    '1': 'Satu',
    '2': 'Dua',
    '3': 'Tiga',
    '4': 'Empat',
    '5': 'Lima',
    '6': 'Enam',
    '7': 'Tujuh',
    '8': 'Delapan',
    '9': 'Sembilan',
    '10': 'Sepuluh',
  };

  static const iqraSeed = <String>[
    'Alif',
    'Ba',
    'Ta',
    'Tsa',
    'Jim',
    'Ha',
    'Kho',
    'Dal',
    'Dzal',
    'Ra',
    'Zai',
    'Sin',
    'Syin',
    'Shod',
    'Dhod',
    'Tho',
    'Zho',
    'Ain',
    'Ghoin',
    'Fa',
    'Qof',
    'Kaf',
    'Lam',
    'Mim',
    'Nun',
    'Wau',
    'Ha',
    'Hamzah',
    'Ya',
  ];

  static const iqraPairs = <Map<String, String>>[
    {'symbol': '\u0627', 'label': 'Alif'},
    {'symbol': '\u0628', 'label': 'Ba'},
    {'symbol': '\u062A', 'label': 'Ta'},
    {'symbol': '\u062B', 'label': 'Tsa'},
    {'symbol': '\u062C', 'label': 'Jim'},
    {'symbol': '\u062D', 'label': 'Ha'},
    {'symbol': '\u062E', 'label': 'Kho'},
    {'symbol': '\u062F', 'label': 'Dal'},
    {'symbol': '\u0630', 'label': 'Dzal'},
    {'symbol': '\u0631', 'label': 'Ra'},
    {'symbol': '\u0632', 'label': 'Zai'},
    {'symbol': '\u0633', 'label': 'Sin'},
    {'symbol': '\u0634', 'label': 'Syin'},
    {'symbol': '\u0635', 'label': 'Shod'},
    {'symbol': '\u0636', 'label': 'Dhod'},
    {'symbol': '\u0637', 'label': 'Tho'},
    {'symbol': '\u0638', 'label': 'Zho'},
    {'symbol': '\u0639', 'label': 'Ain'},
    {'symbol': '\u063A', 'label': 'Ghoin'},
    {'symbol': '\u0641', 'label': 'Fa'},
    {'symbol': '\u0642', 'label': 'Qof'},
    {'symbol': '\u0643', 'label': 'Kaf'},
    {'symbol': '\u0644', 'label': 'Lam'},
    {'symbol': '\u0645', 'label': 'Mim'},
    {'symbol': '\u0646', 'label': 'Nun'},
    {'symbol': '\u0648', 'label': 'Wau'},
    {'symbol': '\u0647', 'label': 'Ha'},
    {'symbol': '\u0621', 'label': 'Hamzah'},
    {'symbol': '\u064A', 'label': 'Ya'},
  ];

  static int totalForCategory(String category) {
    return switch (category) {
      LearningCategories.huruf => hurufSeed.length,
      LearningCategories.angka => angkaSeed.length,
      LearningCategories.benda => bendaSeed.length,
      LearningCategories.iqra => iqraSeed.length,
      LearningCategories.modeSeru => 1,
      _ => 0,
    };
  }
}

class DefaultStorageFiles {
  const DefaultStorageFiles._();

  static const hurufImage = 'images/huruf/default_huruf.png';
  static const angkaImage = 'images/huruf/default_angka.png';
  static const bendaImage = 'images/benda/default_benda.png';
  static const iqraImage = 'images/huruf/default_iqra.png';
  static const laguImage = 'images/benda/default_lagu.png';
  static const badgeHuruf = 'images/badge/badge_huruf.png';
  static const badgeAngka = 'images/badge/badge_angka.png';
  static const badgeBenda = 'images/badge/badge_benda.png';
  static const badgeIqra = 'images/badge/badge_iqra.png';
  static const badgeComplete = 'images/badge/badge_complete.png';
  static const profileBoy = 'images/profile/profile_boy.png';
  static const profileGirl = 'images/profile/profile_girl.png';
}

String defaultMediaFallback(String category) {
  return switch (MediaSourceHelper.normalizeCategory(category)) {
    LearningCategories.angka => DefaultLearningCatalog.angkaPlaceholderAsset,
    LearningCategories.benda => DefaultLearningCatalog.bendaPlaceholderAsset,
    LearningCategories.iqra => DefaultLearningCatalog.iqraPlaceholderAsset,
    LearningCategories.lagu => DefaultLearningCatalog.laguPlaceholderAsset,
    _ => DefaultLearningCatalog.hurufPlaceholderAsset,
  };
}
