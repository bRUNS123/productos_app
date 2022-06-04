import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import '../models/products.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseURL = 'bones.webmul.com';
  final List<Product> products = [];

  late Product selectedProduct;

  bool isLoading = true;
  bool isSaving = false;

  //Hacer fetch de productos.
  ProductsService() {
    loadProducts();
  }

//TODO <List<Product>>
  Future loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(
        _baseURL, 'api/buscar/productosporcategorias/electrodomesticos');
    final resp = await http.get(url);

    final Map<String, dynamic> resultsMap = json.decode(resp.body);

    final List<dynamic> productosMap = resultsMap['results'];

    productosMap.forEach((element) {
      final tempProduct = Product.fromMap(element);
      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();
    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();
    if (product.id == null) {
      //No tengo producto, es necesario crear.
    } else {
      //Actualizar
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseURL, 'api/productos/${product.id}');
    final resp = await http.put(url, body: product.toJson(), headers: {
      "x-token":
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiI2Mjg1NDU0ZjFhOTRkNmQ1MTBkZjYzZjgiLCJpYXQiOjE2NTQzNzEyNjcsImV4cCI6MTY1NDM4NTY2N30.SjXSNHAmIua8fmMNb8MO7qkP_g2ZqkVrLaQUhJRxUFk"
    });
    final decodedData = resp.body;
    print(product.toJson());

    print(decodedData);

    //Actualizar listado de productos

    return product.id!;
  }
}
