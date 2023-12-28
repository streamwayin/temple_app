class AppUpdateModel {
  String version;
  bool mandatory;
  String relesedAt;

  AppUpdateModel({
    required this.version,
    required this.mandatory,
    required this.relesedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'mandatory': mandatory,
      'relesedAt': relesedAt,
    };
  }

  factory AppUpdateModel.fromJson(Map<String, dynamic> map) {
    return AppUpdateModel(
      version: map['version'] ?? '',
      mandatory: map['mandatory'] ?? false,
      relesedAt: map['relesedAt'] ?? '',
    );
  }
}
