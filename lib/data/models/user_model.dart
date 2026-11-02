
class UserModel {
  final int? id;
  final String name;
  final String email;
  final String? whatsapp;
  final String? domisili;
  final String? role;
  final String? fotoProfil;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.whatsapp,
    this.domisili,
    this.role,
    this.fotoProfil,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      whatsapp: json['whatsapp']?.toString(),
      domisili: json['domisili']?.toString(),
      role: json['role']?.toString(),
      fotoProfil: json['foto_profil']?.toString(),
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
      'foto_profil': fotoProfil,
    };
  }
}
