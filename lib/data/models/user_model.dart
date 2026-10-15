class UserModel {
  final int? id;
  final String name;
  final String email;
  final String? whatsapp;
  final String? domisili;
  final String? role;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.whatsapp,
    this.domisili,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      whatsapp: json['whatsapp']?.toString(),
      domisili: json['domisili']?.toString(),
      role: json['role']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'whatsapp': whatsapp,
      'domisili': domisili,
      'role': role,
    };
  }
}