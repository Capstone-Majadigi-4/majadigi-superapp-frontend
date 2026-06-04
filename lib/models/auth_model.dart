class User {
  final String id;
  final String nik;
  final String nama;
  final String email;
  final String noHp;
  final String domicile;
  final String educationLevel;
  final String university;

  User({
    required this.id,
    required this.nik,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.domicile,
    required this.educationLevel,
    required this.university,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      nik: json['nik'] as String? ?? '235267177271112671621672',
      nama: json['nama'] as String? ?? 'Christ James',
      email: json['email'] as String? ?? 'warga.malang@email.com',
      noHp: json['no_hp'] as String? ?? '+62 812 3456 7890',
      domicile: json['domicile'] as String? ?? 'Kota Malang, Jawa Timur',
      educationLevel: json['education_level'] as String? ?? 'S1 Teknik Informatika',
      university: json['university'] as String? ?? 'Universitas Brawijaya',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nik': nik,
      'nama': nama,
      'email': email,
      'no_hp': noHp,
      'domicile': domicile,
      'education_level': educationLevel,
      'university': university,
    };
  }
}

class AuthData {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final User user;

  AuthData({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      accessToken: json['access_token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
      expiresIn: json['expires_in'] as int? ?? 0,
      user: User.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_in': expiresIn,
      'user': user.toJson(),
    };
  }
}

class LoginResponse {
  final String status;
  final String message;
  final AuthData? data;

  LoginResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] as String? ?? 'error',
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? AuthData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}
