class GetAllChats {
  GetAllChats({
    required this.id,
    required this.name,
    required this.company,
    required this.image,
    required this.lastMessage,
    required this.read,
    required this.friendId,
  });

  int id;
  String name;
  String company;
  String image;
  String lastMessage;
  bool read;
  int friendId;

  factory GetAllChats.fromJson(Map<String, dynamic> json) => GetAllChats(
      id: json["id"] ?? '',
      name: json["name"] ?? '',
      company: json["company"] ?? '',
      image: json["image"] ?? '',
      lastMessage: json["lastMessage"] ?? '',
      read: json["read"] ?? false,
      friendId: json['friendId'] ?? 0);
}
