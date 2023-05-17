class Channel {
  final String id;
  final String name;
  final List<String> altNames;
  final String network;
  final List<String> owners;
  final String country;
  final String subdivision;
  final String city;
  final List<String> broadcastArea;
  final List<String> languages;
  final List<String> categories;
  final bool isNsfw;
  final DateTime? launched;
  final DateTime? closed;
  final String? replacedBy;
  final String? website;
  final String logo;

  Channel({
    required this.id,
    required this.name,
    required this.altNames,
    required this.network,
    required this.owners,
    required this.country,
    required this.subdivision,
    required this.city,
    required this.broadcastArea,
    required this.languages,
    required this.categories,
    required this.isNsfw,
    required this.launched,
    required this.closed,
    required this.replacedBy,
    required this.website,
    required this.logo,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      altNames: List<String>.from(json['alt_names'] ?? []),
      network: json['network'] ?? '',
      owners: List<String>.from(json['owners'] ?? []),
      country: json['country'] ?? '',
      subdivision: json['subdivision'] ?? '',
      city: json['city'] ?? '',
      broadcastArea: List<String>.from(json['broadcast_area'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      categories: List<String>.from(json['categories'] ?? []),
      isNsfw: json['is_nsfw'] ?? false,
      launched: json['launched'] != null ? DateTime.parse(json['launched']) : null,
      closed: json['closed'] != null ? DateTime.parse(json['closed']) : null,
      replacedBy: json['replaced_by'],
      website: json['website'],
      logo: json['logo'] ?? '',
    );
  }
}
