class GetAllTimes {
  GetAllTimes({
    required this.id,
    required this.roomTime,
  });

  int id;
  String roomTime;

  factory GetAllTimes.fromJson(Map<String, dynamic> json) => GetAllTimes(
    id: json["id"],
    roomTime: json["roomTime"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "roomTime": roomTime,
  };
}
