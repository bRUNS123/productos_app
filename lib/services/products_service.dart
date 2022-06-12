import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos_app/models/models.dart';

import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseURL2 = '206.189.99.159:3000';
  final String _baseURL = '10.0.2.2:3000';
  final List<Product> products = [];
  File? newPictureFile;

  final storage = const FlutterSecureStorage();
  // final token = getToken();
  // final headers = {
  //   "x-token":token;
  //      ,
  //   "Content-Type": "application/json"
  // };
  // final headers = {
  //   "x-token":
  //       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiI2Mjg1NDU0ZjFhOTRkNmQ1MTBkZjYzZjgiLCJpYXQiOjE2NTQ5NjgyOTEsImV4cCI6MTY1NDk4MjY5MX0.8MVG7piQ8wnItH5NVeci6Em8Dzb8njSUvljuAvumIdU",
  //   "Content-Type": "application/json"
  // };

  Future<Map<String, String>> getToken() async {
    final token = await storage.read(key: 'token');
    print('Token: ${token}');
    return {"x-token": token!, "Content-Type": "application/json"};
  }

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

//Cambiar a https si es en producciòn
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

  Future saveOrCreateProduct(Product product, String imageUrl) async {
    isSaving = true;
    notifyListeners();
    if (product.id == null) {
      //No tengo producto, es necesario crear.
      await createProduct(product, imageUrl);
    } else {
      //Actualizar
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    Map<String, String> headers = await getToken();
    // final headers = {"x-token": token, "Content-Type": "application/json"};

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

  Future<String> createProduct(Product product, String imageUrl) async {
    try {
      final url = Uri.http(_baseURL, 'api/productos');
      final productToBack = {
        'nombre': product.nombre,
        'precio': product.precio,
        'disponible': product.disponible,
        'img': imageUrl,
        'categoria': {
          '_id': product.categoria!.id,
        },
      };

      String jsonProduct = json.encode(productToBack);
      Map<String, String> headers = await getToken();

      final resp = await http.post(url, body: jsonProduct, headers: headers);

      if (resp.statusCode != 201) {
        print('Error');
        return 'Error en la petición';
      }

      print('jsonProduct: ${jsonProduct}');
      print('respBody: ${resp.body}');
      final Map<String, dynamic> decodeProduct = json.decode(resp.body);
      final decodeProductId = decodeProduct['id'];
      print(decodeProductId);
      products.add(product);

      return decodeProductId;
    } catch (e) {
      if (e is TimeoutException) {
        print('Error Internet');

        return 'ERROR INTERNET';
      } else if (e is SocketException) {
        return 'ERROR SOCKET';
      } else
        print(e);
      return 'ERROR SOLICITUD';
    }
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.img = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;
    isSaving = true;
    notifyListeners();

    // final url = Uri.http(_baseURL, 'api/uploads');
    final url = Uri.parse('http://10.0.2.2:3000/api/uploads');
    // Map<String, String> headers = <String, String>{
    //   "Content-Type": 'multipart/form-data'
    // };

    final imageUploadRequest = http.MultipartRequest('POST', url);
    // ..headers.addAll(headers);
    final file =
        await http.MultipartFile.fromPath('archivo', newPictureFile!.path);

    // print('file: ${file.filename}');
    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    // print('newpicture: ${newPictureFile!.path}');

    print('resp.body: ${resp.body}');

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Error en el servidor');
      print(resp.body);
      return null;
    }
    newPictureFile = null;
    final decodedData = json.decode(resp.body);
    return decodedData['nombre'];
  }
}
