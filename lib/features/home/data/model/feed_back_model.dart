class FeedBackModel {
  int id;
  String formUrl;
  bool active;

  FeedBackModel(
      {required this.id, required this.active, required this.formUrl});

  factory FeedBackModel.fromJson(Map<String, dynamic> json) {
    return FeedBackModel(
        id: json['id'], formUrl: json['formUrl'], active: json['active']);
  }
}
