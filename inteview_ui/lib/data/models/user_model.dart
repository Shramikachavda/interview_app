class User {
  final int id;
  final String name;
  final String email;
  final String level;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.level,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print("👤 User JSON: $json");
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'level': level,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? level,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      level: level ?? this.level,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              email == other.email &&
              level == other.level;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ email.hashCode ^ level.hashCode;

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, level: $level)';
  }
}



class LoginResponse {
  final String accessToken;
  final String tokenType;
  final User user;

  LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {

    print("📦 LoginResponse JSON: $json");
    return LoginResponse(
      accessToken: json['access_token'] ?? '',
      tokenType: json['token_type'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'user': user.toJson(),
    };
  }

  LoginResponse copyWith({
    String? accessToken,
    String? tokenType,
    User? user,
  }) {
    return LoginResponse(
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
      user: user ?? this.user,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LoginResponse &&
              runtimeType == other.runtimeType &&
              accessToken == other.accessToken &&
              tokenType == other.tokenType &&
              user == other.user;

  @override
  int get hashCode =>
      accessToken.hashCode ^ tokenType.hashCode ^ user.hashCode;

  @override
  String toString() {
    return 'LoginResponse(accessToken: $accessToken, tokenType: $tokenType, user: $user)';
  }
}
