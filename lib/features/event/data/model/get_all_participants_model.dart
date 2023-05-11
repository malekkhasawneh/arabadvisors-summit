class AllParticipantsModel {
  AllParticipantsModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNo,
    required this.company,
    required this.country,
    required this.jobTitle,
    required this.industry,
    required this.connectionStatus,
    required this.image,
    required this.chatId,
    required this.isModerator,
  });

  int id;
  String name;
  String email;
  String mobileNo;
  String company;
  String country;
  String jobTitle;
  String industry;
  String connectionStatus;
  String image;
  int chatId;
  bool isModerator;

  factory AllParticipantsModel.fromJson(Map<String, dynamic> json) =>
      AllParticipantsModel(
        id: json["id"],
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        mobileNo: json["mobileNo"] ?? '',
        company: json["company"] ?? '',
        country: json["country"] ?? '',
        jobTitle: json["jobTitle"] ?? '',
        industry: json["industry"] ?? '',
        connectionStatus: json["connectionStatus"] ?? '',
        image: json["image"] ?? '',
        chatId: json["chatId"] ?? 0,
        isModerator: false,
      );
}
