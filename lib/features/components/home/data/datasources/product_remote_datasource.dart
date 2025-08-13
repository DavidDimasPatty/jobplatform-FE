import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  Future<List<UserModel>> getProducts() async {
    final response = await http.get(
      Uri.parse('https://api.example.com/products'),
    );

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => UserModel.fromJson(e)).toList();
    // List<UserModel> data = [];
    // return data;
  }
}
