class GetAllIndustryModel {
  GetAllIndustryModel({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory GetAllIndustryModel.fromJson(Map<String, dynamic> json) =>
      GetAllIndustryModel(
        id: json["id"],
        name: json["name"],
      );
}
