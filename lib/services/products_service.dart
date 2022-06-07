import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import '../models/products.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseURL = '206.189.99.159:3000';
  final List<Product> products = [];
  final headers = {
    "x-token":
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiI2Mjg1NDU0ZjFhOTRkNmQ1MTBkZjYzZjgiLCJpYXQiOjE2NTQ2MTc5MDcsImV4cCI6MTY1NDYzMjMwN30.GcAW1rEtRQ7crmFTRPUnSk1Ppao8KDMKu3e_XB7JqFk",
    "Content-Type": "application/json"
  };

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

    final url = Uri.http(
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
      await createProduct(product);
    } else {
      //Actualizar
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.http(_baseURL, 'api/productos/${product.id}');
    final resp = await http.put(url, body: product.toJson(), headers: headers);
    final decodedData = resp.body;

    // print(msg and resp);
    print(product.toJson());
    print(decodedData);

    //Actualizar listado de productos
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.http(_baseURL, 'api/productos');
    final resp = await http.post(url, body: product.toJson(), headers: headers);
    final decodedData = resp.body;

    // print(msg and resp);
    print('create');
    print(product.toJson());
    print(decodedData);

    return product.id!;
  }
}
