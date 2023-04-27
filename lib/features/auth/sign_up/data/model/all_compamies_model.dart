class GetAllCompanyModel {
  GetAllCompanyModel({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory GetAllCompanyModel.fromJson(Map<String, dynamic> json) =>
      GetAllCompanyModel(
        id: json["id"],
        name: json["name"],
      );
}
