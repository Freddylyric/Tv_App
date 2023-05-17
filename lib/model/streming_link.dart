class StreamingLink {
  late final String channel;
  final String url;
  final String httpReferrer;
  final String userAgent;
  final String status;
  final int width;
  final int height;
  final int bitrate;
  final double frameRate;
  final DateTime addedAt;
  final DateTime updatedAt;
  final DateTime checkedAt;

  StreamingLink({
    required this.channel,
    required this.url,
    required this.httpReferrer,
    required this.userAgent,
    required this.status,
    required this.width,
    required this.height,
    required this.bitrate,
    required this.frameRate,
    required this.addedAt,
    required this.updatedAt,
    required this.checkedAt,
  });

  factory StreamingLink.fromJson(Map<String, dynamic> json) {
    return StreamingLink(
      channel: json['channel'],
      url: json['url'].toString(),
      httpReferrer: json['http_referrer'] ?? "",
      userAgent: json['user_agent'] ?? "",
      status: json['status'] ?? "",
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      bitrate: json['bitrate'] ?? 0,
      frameRate: json['frame_rate'] != null ? json['frame_rate'].toDouble() : 0.0,
      addedAt: DateTime.parse(json['added_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      checkedAt: DateTime.parse(json['checked_at']),
    );
  }
}
