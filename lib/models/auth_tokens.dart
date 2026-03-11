class AuthTokens {
  final String access;
  final String refresh;

  AuthTokens({
    required this.access,
    required this.refresh,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      access: json['access']?.toString() ?? '',
      refresh: json['refresh']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'access': access,
      'refresh': refresh,
    };
  }
}

