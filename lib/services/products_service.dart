import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import '../models/products.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseURL = 'bones.webmul.com';
  final List<Result> products = [];
  bool isLoading = true;

  //Hacer fetch de productos.
  ProductsService() {
    loadProducts();
  }

//TODO <List<Product>>
  Future loadProducts() async {
    final url = Uri.https(_baseURL, 'api/buscar/productosporcategorias/abc123');
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);
    productsMap.forEach((key, value) {
      final tempProduct = Result.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });
    print(products[0].nombre);
    print(productsMap);
  }
}
