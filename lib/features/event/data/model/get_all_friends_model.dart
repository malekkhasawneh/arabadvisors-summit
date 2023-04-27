class GetAllFriendsModel {
  GetAllFriendsModel({
    required this.id,
    required this.person,
    required this.friendId,
    required this.modified,
    required this.status,
  });

  int id;
  Person person;
  int friendId;
  DateTime modified;
  String status;

  factory GetAllFriendsModel.fromJson(Map<String, dynamic> json) => GetAllFriendsModel(
    id: json["id"],
    person: Person.fromJson(json["person"]),
    friendId: json["friendId"],
    modified: DateTime.parse(json["modified"]),
    status: json["status"],
  );
}

class Person {
  Person({
    required this.name,
    required this.email,
    required this.mobileNo,
    this.profilePicture,
    required this.company,
    required this.country,
    required this.industry,
    required this.jobTitle,
  });

  String name;
  String email;
  String mobileNo;
  dynamic profilePicture;
  Company company;
  Country country;
  Company industry;
  String jobTitle;

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    name: json["name"],
    email: json["email"],
    mobileNo: json["mobile_no"],
    profilePicture: json["profilePicture"],
    company: Company.fromJson(json["company"]),
    country: Country.fromJson(json["country"]),
    industry: Company.fromJson(json["industry"]),
    jobTitle: json["jobTitle"],
  );
}

class Company {
  Company({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"],
    name: json["name"],
  );
}

class Country {
  Country({
    required this.id,
    required this.name,
    required this.countryCode,
  });

  int id;
  String name;
  String countryCode;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    name: json["name"],
    countryCode: json["countryCode"],
  );
}
