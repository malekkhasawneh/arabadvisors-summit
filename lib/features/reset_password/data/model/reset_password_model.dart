class ResetPasswordModel {
  final String message;
  final int statusCode;

  ResetPasswordModel({required this.message, required this.statusCode});

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordModel(
        message: json['message'], statusCode: json['statusCode']);
  }
}
