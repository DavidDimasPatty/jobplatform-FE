import 'package:flutter/material.dart';
import 'package:job_platform/features/shared/TopAppLayout.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GetProductsUseCase getProductsUseCase;
  List products = [];

  @override
  void initState() {
    super.initState();
    final remoteDataSource = ProductRemoteDataSource();
    final repository = ProductRepositoryImpl(remoteDataSource);
    getProductsUseCase = GetProductsUseCase(repository);
    fetchData();
  }

  void fetchData() async {
    final result = await getProductsUseCase.execute();
    setState(() {
      products = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopApplayout(),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('Rp ${product.price}'),
          );
        },
      ),
    );
  }
}
