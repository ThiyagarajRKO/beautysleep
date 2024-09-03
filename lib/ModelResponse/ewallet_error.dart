class ErrorResponse {
  final String? error;
  final String? errorDescription;

  ErrorResponse({
    this.error,
    this.errorDescription,
  });

  ErrorResponse.fromJson(Map<String, dynamic> json)
      : error = json['error'] as String?,
        errorDescription = json['error_description'] as String?;

  Map<String, dynamic> toJson() => {
    'error' : error,
    'error_description' : errorDescription
  };
}