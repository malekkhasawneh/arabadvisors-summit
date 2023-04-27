class GetMessages {
  GetMessages({
    required this.name,
    required this.company,
    required this.image,
    required this.message,
    required this.timestamp,
  });

  String name;
  String company;
  String image;
  String message;
  DateTime timestamp;

  factory GetMessages.fromJson(Map<String, dynamic> json) => GetMessages(
        name: json["name"] ?? '',
        company: json["company"] ?? '',
        image: json["image"] ?? '',
        message: json["message"] ?? '',
        timestamp:
            DateTime.parse(json["timestamp"] ?? DateTime.now().toString()),
      );
}
