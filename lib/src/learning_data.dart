part of '../main.dart';

const _hurufAsset = DefaultLearningCatalog.hurufPlaceholderAsset;
const _angkaAsset = DefaultLearningCatalog.angkaPlaceholderAsset;
const _bendaAsset = DefaultLearningCatalog.bendaPlaceholderAsset;

final defaultLettersData = [
  LetterGroup('A', [LearningObject('Apel', _hurufAsset, 'buah')]),
  LetterGroup('B', [LearningObject('Bola', _hurufAsset, 'mainan')]),
  LetterGroup('C', [LearningObject('Cicak', _hurufAsset, 'hewan')]),
  LetterGroup('D', [LearningObject('Domba', _hurufAsset, 'hewan')]),
  LetterGroup('E', [LearningObject('Elang', _hurufAsset, 'hewan')]),
  LetterGroup('F', [LearningObject('Foto', _hurufAsset)]),
  LetterGroup('G', [LearningObject('Gajah', _hurufAsset, 'hewan')]),
  LetterGroup('H', [LearningObject('Harimau', _hurufAsset, 'hewan')]),
  LetterGroup('I', [LearningObject('Ikan', _hurufAsset, 'hewan')]),
  LetterGroup('J', [LearningObject('Jeruk', _hurufAsset, 'buah')]),
  LetterGroup('K', [LearningObject('Kucing', _hurufAsset, 'hewan')]),
  LetterGroup('L', [LearningObject('Lampu', _hurufAsset)]),
  LetterGroup('M', [LearningObject('Mobil', _hurufAsset, 'kendaraan')]),
  LetterGroup('N', [LearningObject('Nanas', _hurufAsset, 'buah')]),
  LetterGroup('O', [LearningObject('Obeng', _hurufAsset)]),
  LetterGroup('P', [LearningObject('Pisang', _hurufAsset, 'buah')]),
  LetterGroup('Q', [LearningObject('Quran', _hurufAsset)]),
  LetterGroup('R', [LearningObject('Rumah', _hurufAsset)]),
  LetterGroup('S', [LearningObject('Sepeda', _hurufAsset, 'kendaraan')]),
  LetterGroup('T', [LearningObject('Tomat', _hurufAsset, 'buah')]),
  LetterGroup('U', [LearningObject('Ular', _hurufAsset, 'hewan')]),
  LetterGroup('V', [LearningObject('Vas', _hurufAsset)]),
  LetterGroup('W', [LearningObject('Wortel', _hurufAsset, 'buah')]),
  LetterGroup('X', [LearningObject('Xylophone', _hurufAsset)]),
  LetterGroup('Y', [LearningObject('Yo-yo', _hurufAsset, 'mainan')]),
  LetterGroup('Z', [LearningObject('Zebra', _hurufAsset, 'hewan')]),
];

const defaultNumbersData = [
  NumberItem('1', 'Satu', _angkaAsset),
  NumberItem('2', 'Dua', _angkaAsset),
  NumberItem('3', 'Tiga', _angkaAsset),
  NumberItem('4', 'Empat', _angkaAsset),
  NumberItem('5', 'Lima', _angkaAsset),
  NumberItem('6', 'Enam', _angkaAsset),
  NumberItem('7', 'Tujuh', _angkaAsset),
  NumberItem('8', 'Delapan', _angkaAsset),
  NumberItem('9', 'Sembilan', _angkaAsset),
  NumberItem('10', 'Sepuluh', _angkaAsset),
];

const objectsData = [
  LearningObject('Mobil', _bendaAsset, 'kendaraan'),
  LearningObject('Rumah', _bendaAsset, 'benda'),
  LearningObject('Sepeda', _bendaAsset, 'kendaraan'),
  LearningObject('Meja', _bendaAsset, 'alat sekolah'),
  LearningObject('Kursi', _bendaAsset, 'alat sekolah'),
  LearningObject('Buku', _bendaAsset, 'alat sekolah'),
  LearningObject('Pensil', _bendaAsset, 'alat sekolah'),
  LearningObject('Tas', _bendaAsset, 'alat sekolah'),
];

const iqraData = [
  IqraItem('\u0627', 'Alif'),
  IqraItem('\u0628', 'Ba'),
  IqraItem('\u062A', 'Ta'),
  IqraItem('\u062B', 'Tsa'),
  IqraItem('\u062C', 'Jim'),
  IqraItem('\u062D', 'Ha'),
  IqraItem('\u062E', 'Kho'),
  IqraItem('\u062F', 'Dal'),
  IqraItem('\u0630', 'Dzal'),
  IqraItem('\u0631', 'Ra'),
  IqraItem('\u0632', 'Zai'),
  IqraItem('\u0633', 'Sin'),
  IqraItem('\u0634', 'Syin'),
  IqraItem('\u0635', 'Shod'),
  IqraItem('\u0636', 'Dhod'),
  IqraItem('\u0637', 'Tho'),
  IqraItem('\u0638', 'Zho'),
  IqraItem('\u0639', 'Ain'),
  IqraItem('\u063A', 'Ghoin'),
  IqraItem('\u0641', 'Fa'),
  IqraItem('\u0642', 'Qof'),
  IqraItem('\u0643', 'Kaf'),
  IqraItem('\u0644', 'Lam'),
  IqraItem('\u0645', 'Mim'),
  IqraItem('\u0646', 'Nun'),
  IqraItem('\u0648', 'Wau'),
  IqraItem('\u0647', 'Ha'),
  IqraItem('\u0621', 'Hamzah'),
  IqraItem('\u064A', 'Ya'),
];

const songsData = <SongItem>[];
