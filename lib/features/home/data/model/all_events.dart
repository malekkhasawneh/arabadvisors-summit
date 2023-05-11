class GetAllEvents {
  GetAllEvents({
    required this.itemId,
    required this.moderatorIds,
    required this.panelistsIds,
    required this.title,
    required this.desc,
    required this.time,
    required this.titles,

  });

  int itemId;
  String moderatorIds;
  String panelistsIds;
  String title;
  String desc;
  String time;
  String titles;


  factory GetAllEvents.fromJson(Map<String, dynamic> json) => GetAllEvents(
        itemId: json["itemId"] ?? 0,
        moderatorIds: json["moderatorIds"] ?? '',
        panelistsIds: json["panelistsIds"] ?? '',
        title: json["title"] ?? '',
        desc: json["desc"] ?? '',
        time: json["time"] ?? '',
        titles: json["titles"] ?? '',

      );
}
