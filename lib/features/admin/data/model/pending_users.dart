class GetAllPendingUsers {
  GetAllPendingUsers({
    required this.id,
    required this.name,
    required this.email,
    required this.number,
    required this.jobTitle,
    required this.company,
    required this.country,
    required this.industry,
  });

  int id;
  String name;
  String email;
  String number;
  String jobTitle;
  String company;
  String country;
  String industry;

  factory GetAllPendingUsers.fromJson(Map<String, dynamic> json) => GetAllPendingUsers(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    number: json["number"],
    jobTitle: json["jobTitle"],
    company: json["company"],
    country: json["country"],
    industry: json["industry"],
  );
}
