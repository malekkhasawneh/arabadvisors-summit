class AllMeetingsModel {
  AllMeetingsModel({
    required this.id,
    required this.meetingTime,
    required this.meetingDate,
    required this.meetingRoom,
    required this.meetingStatus,
    required this.inviterId,
    required this.inviterName,
    required this.inviterCompany,
    required this.inviterImage,
    required this.invitedId,
    required this.invitedName,
    required this.invitedCompany,
    required this.invitedImage,
    required this.rescheduledById,
  });

  int id;
  String meetingTime;
  String meetingDate;
  String meetingRoom;
  String meetingStatus;
  int inviterId;
  String inviterName;
  String inviterCompany;
  String inviterImage;
  int invitedId;
  String invitedName;
  String invitedCompany;
  String invitedImage;
  int rescheduledById;

  factory AllMeetingsModel.fromJson(Map<String, dynamic> json) =>
      AllMeetingsModel(
        id: json["id"] ?? 0,
        meetingTime: json["meetingTime"] ?? '',
        meetingDate: json["meetingDate"] ?? '',
        meetingRoom: json["meetingRoom"] ?? '',
        meetingStatus: json["meetingStatus"] ?? '',
        inviterId: json["inviterId"] ?? 0,
        inviterName: json["inviterName"] ?? '',
        inviterCompany: json["inviterCompany"] ?? '',
        inviterImage: json["inviterImage"] ?? '',
        invitedId: json["invitedId"] ?? 0,
        invitedName: json["invitedName"] ?? '',
        invitedCompany: json["invitedCompany"] ?? '',
        invitedImage: json["invitedImage"] ?? '',
        rescheduledById: json["rescheduledById"] ?? 0,
      );
}
