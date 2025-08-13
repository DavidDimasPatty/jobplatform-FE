class UserModel {
  final String id;
  final String name;
  final double price;

  UserModel({required this.id, required this.name, required this.price});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
    );
  }
}
