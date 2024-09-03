class TokenResponse {
  final String? accessToken;
  final dynamic expiresIn;
  final String? refreshToken;
  final String? tokenType;

  TokenResponse({
    this.accessToken,
    this.expiresIn,
    this.refreshToken,
    this.tokenType,
  });

  TokenResponse.fromJson(Map<String, dynamic> json)
      : accessToken = json['access_token'] as String?,
        expiresIn = json['expires_in'] ,
        refreshToken = json['refresh_token'] as String?,
        tokenType = json['token_type'] as String?;

  Map<String, dynamic> toJson() => {
    'access_token' : accessToken,
    'expires_in' : expiresIn,
    'refresh_token' : refreshToken,
    'token_type' : tokenType
  };
}