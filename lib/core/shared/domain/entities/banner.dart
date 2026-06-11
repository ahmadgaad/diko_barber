enum CampaignType {
  salon,
  service,
  package,
  unknown;

  static CampaignType fromString(String? value) => switch (value) {
        'salon' => CampaignType.salon,
        'service' => CampaignType.service,
        'package' => CampaignType.package,
        _ => CampaignType.unknown,
      };
}

class Banner {
  const Banner({
    required this.campaignId,
    required this.title,
    required this.description,
    required this.image,
    required this.campaignType,
    required this.targetId,
    required this.salonId,
    this.externalLink,
    this.trackingToken,
    this.priorityLevel = 0,
  });

  final int campaignId;
  final String title;
  final String description;
  final String image;
  final CampaignType campaignType;
  final int targetId;
  final int salonId;
  final String? externalLink;
  final String? trackingToken;
  final int priorityLevel;

  bool get isFeatured => priorityLevel == 1;
}
