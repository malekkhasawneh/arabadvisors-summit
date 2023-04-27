class GetAllCountryModel {
  GetAllCountryModel({
    required this.id,
    required this.name,
    required this.countryCode,
  });

  int id;
  String name;
  String countryCode;

  factory GetAllCountryModel.fromJson(Map<String, dynamic> json) =>
      GetAllCountryModel(
        id: json["id"],
        name: json["name"],
        countryCode: json["countryCode"],
      );
}
