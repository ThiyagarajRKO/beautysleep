class UploadResponse {
  String? message;
  bool? error;
  String? data;

  UploadResponse({this.message, this.error, this.data});

  UploadResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    error = json['error'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['error'] = error;
    data['data'] = this.data;
    return data;
  }
}