// To parse this JSON data, do
//
//     final product = productFromMap(jsonString);

import 'dart:convert';

Product productFromMap(String str) => Product.fromMap(json.decode(str));

String productToMap(Product data) => json.encode(data.toMap());

class Product {
  Product({
    this.id,
    required this.nombre,
    required this.precio,
    this.categoria,
    required this.disponible,
    this.img,
  });

  String? id;
  String nombre;
  double precio;
  Categoria? categoria;
  bool disponible;
  String? img;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["_id"],
        nombre: json["nombre"],
        precio: json["precio"].toDouble(),
        categoria: Categoria.fromMap(json["categoria"]),
        disponible: json["disponible"],
        img: json["img"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "nombre": nombre,
        "precio": precio,
        "categoria": categoria?.toMap(),
        "disponible": disponible,
        "img": img,
      };
  Product copy() => Product(
        id: id,
        nombre: nombre,
        precio: precio,
        categoria: categoria,
        disponible: disponible,
        img: img,
      );
}

class Categoria {
  Categoria({
    required this.id,
    required this.nombre,
  });

  String id;
  String nombre;

  factory Categoria.fromMap(Map<String, dynamic> json) => Categoria(
        id: json["_id"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "nombre": nombre,
      };
}
