import 'package:ronaq_barber/features/onboarding/domain/entities/onboarding_item.dart';

class OnboardingItemModel extends OnboardingItem {
  const OnboardingItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
  });

  factory OnboardingItemModel.fromJson(Map<String, dynamic> json) =>
      OnboardingItemModel(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String,
        imageUrl: json['image'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'image': imageUrl,
      };
}
