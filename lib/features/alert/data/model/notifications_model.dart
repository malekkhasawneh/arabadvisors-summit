class NotificationsModel {
  NotificationsModel({
    required this.name,
    required this.companyName,
    required this.type,
    required this.id,
    required this.photoUrl,
    required this.status,
    required this.localDateTime,
    required this.objectId,
  });

  String name;
  String companyName;
  String type;
  int id;
  String photoUrl;
  String status;
  DateTime localDateTime;
  int objectId;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      NotificationsModel(
        name: json["name"] ?? '',
        companyName: json["companyName"] ?? '',
        type: json["type"] ?? '',
        id: json["id"] ?? 0,
        photoUrl: json["photoUrl"] ?? '',
        status: json["status"] ?? '',
        localDateTime:
            DateTime.parse(json["localDateTime"] ?? DateTime.now().toString()),
        objectId: json['objectId'],
      );
}
