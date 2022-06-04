import 'package:flutter/material.dart';
import '../models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Product product;
  ProductFormProvider(this.product);

  updateAvailability(bool value) {
    print(value);
    product.disponible = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(product.nombre);
    print(product.precio);
    print(product.disponible);
    return formKey.currentState?.validate() ?? false;
  }
}
