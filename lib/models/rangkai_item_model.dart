class RangkaiItemModel {
  const RangkaiItemModel({
    required this.id,
    required this.type,
    required this.title,
    required this.target,
    required this.pieces,
    required this.units,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String type;
  final String title;
  final String target;
  final List<String> pieces;
  final List<Map<String, dynamic>> units;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory RangkaiItemModel.fromMap(Map<String, dynamic> map) {
    return RangkaiItemModel(
      id: '${map['id'] ?? ''}'.trim(),
      type: '${map['type'] ?? ''}'.trim(),
      title: '${map['title'] ?? ''}'.trim(),
      target: '${map['target'] ?? ''}'.trim(),
      pieces: (map['pieces'] as List? ?? const [])
          .map((item) => '$item'.trim())
          .where((item) => item.isNotEmpty)
          .toList(),
      units: (map['units'] as List? ?? const [])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList(),
      createdAt: _parseDate(map['created_at']) ?? DateTime.now().toUtc(),
      updatedAt: _parseDate(map['updated_at']) ?? DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'target': target,
      'pieces': pieces,
      'units': units,
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is DateTime) return value.toUtc();
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value)?.toUtc();
    }
    return null;
  }
}
