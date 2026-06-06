import 'package:equatable/equatable.dart';

class MediaInputConfig extends Equatable {
  final int maxFiles;
  final int maxFilePerLanguage;
  final int maxFileSizeMb;
  final List<String> allowedMimeTypes;

  const MediaInputConfig({
    required this.maxFiles,
    required this.maxFilePerLanguage,
    required this.maxFileSizeMb,
    required this.allowedMimeTypes,
  });

  factory MediaInputConfig.fromJson(Map<String, dynamic> json) {
    return MediaInputConfig(
      maxFiles: json['max_files'] ?? 1,
      maxFilePerLanguage: json['max_file_per_language'] ?? 1,
      maxFileSizeMb: json['max_file_size_mb'] ?? 5,
      allowedMimeTypes: (json['allowed_mime_types'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'max_files': maxFiles,
      'max_file_per_language': maxFilePerLanguage,
      'max_file_size_mb': maxFileSizeMb,
      'allowed_mime_types': allowedMimeTypes,
    };
  }

  @override
  List<Object?> get props =>
      [maxFiles, maxFilePerLanguage, maxFileSizeMb, allowedMimeTypes];
}

class MediaUploadAttribute extends Equatable {
  final String modelType;
  final int modelId;
  final String collectionName;
  final bool isSingleFile;
  final bool supportLocalization;
  final MediaInputConfig inputConfig;

  const MediaUploadAttribute({
    required this.modelType,
    required this.modelId,
    required this.collectionName,
    required this.isSingleFile,
    required this.supportLocalization,
    required this.inputConfig,
  });

  factory MediaUploadAttribute.fromJson(Map<String, dynamic> json) {
    return MediaUploadAttribute(
      modelType: json['model_type'] ?? '',
      modelId: json['model_id'] ?? 0,
      collectionName: json['collection_name'] ?? '',
      isSingleFile: json['is_single_file'] ?? false,
      supportLocalization: json['support_localization'] ?? false,
      inputConfig: MediaInputConfig.fromJson(
        json['input_config'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model_type': modelType,
      'model_id': modelId,
      'collection_name': collectionName,
      'is_single_file': isSingleFile,
      'support_localization': supportLocalization,
      'input_config': inputConfig.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        modelType,
        modelId,
        collectionName,
        isSingleFile,
        supportLocalization,
        inputConfig,
      ];
}

class MediaUploadAttributes extends Equatable {
  final Map<String, MediaUploadAttribute> attributes;

  const MediaUploadAttributes({required this.attributes});

  factory MediaUploadAttributes.fromJson(Map<String, dynamic> json) {
    return MediaUploadAttributes(
      attributes: json.map(
        (key, value) => MapEntry(
          key,
          MediaUploadAttribute.fromJson(value as Map<String, dynamic>),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return attributes.map((key, value) => MapEntry(key, value.toJson()));
  }

  MediaUploadAttribute? operator [](String key) => attributes[key];

  @override
  List<Object?> get props => [attributes];
}
