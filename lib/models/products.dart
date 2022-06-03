// To parse this JSON data, do
//
//     final product = productFromMap(jsonString);

import 'dart:convert';

class Product {
  Product({
    this.results,
  });

  List<Result>? results;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        results:
            List<Result>.from(json["results"].map((x) => Result.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "results": List<dynamic>.from(results!.map((x) => x.toMap())),
      };
}

class Result {
  Result({
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

  factory Result.fromJson(String str) => Result.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Result.fromMap(Map<String, dynamic> json) => Result(
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
        "categoria": categoria!.toMap(),
        "disponible": disponible,
        "img": img,
      };
}

class Categoria {
  Categoria({
    this.id,
    required this.nombre,
  });

  String? id;
  String nombre;

  factory Categoria.fromJson(String str) => Categoria.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Categoria.fromMap(Map<String, dynamic> json) => Categoria(
        id: json["_id"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "nombre": nombre,
      };
}
