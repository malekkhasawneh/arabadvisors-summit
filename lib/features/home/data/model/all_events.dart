class GetAllEvents {
  GetAllEvents({
    required this.itemId,
    required this.speakerId,
    required this.title,
    required this.desc,
    required this.time,
  });

  int itemId;
  int speakerId;
  String title;
  String desc;
  String time;

  factory GetAllEvents.fromJson(Map<String, dynamic> json) => GetAllEvents(
    itemId: json["itemId"],
    speakerId: json["speakerId"],
    title: json["title"],
    desc: json["desc"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "itemId": itemId,
    "speakerId": speakerId,
    "title": title,
    "desc": desc,
    "time": time,
  };
}
