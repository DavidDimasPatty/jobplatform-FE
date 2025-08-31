class UserModel {
  final String? id;
  final String? nama;

  UserModel({this.id, this.nama});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['user']['_id'], nama: json['user']['nama']);
  }
}
