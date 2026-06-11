import 'package:ronaq_barber/core/shared/domain/entities/banner.dart';

class BannerModel extends Banner {
  const BannerModel({
    required super.campaignId,
    required super.title,
    required super.description,
    required super.image,
    required super.campaignType,
    required super.targetId,
    required super.salonId,
    super.externalLink,
    super.trackingToken,
    super.priorityLevel,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        campaignId: json['campaign_id'] as int,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        image: json['image'] as String,
        campaignType:
            CampaignType.fromString(json['campaign_type'] as String?),
        targetId: json['target_id'] as int,
        salonId: json['salon_id'] as int,
        externalLink: json['external_link'] as String?,
        trackingToken: json['tracking_token'] as String?,
        priorityLevel: json['priority_level'] as int? ?? 0,
      );
}
