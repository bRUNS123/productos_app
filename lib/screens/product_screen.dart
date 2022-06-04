import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productos_app/providers/product_form_provider.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';
import '../ui/input_decoration.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productService.selectedProduct),
      child: _ProductScreenBody(
        productService: productService,
      ),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  final ProductsService productService;

  const _ProductScreenBody({
    required this.productService,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(
                  url: productService.selectedProduct.img,
                ),
                Positioned(
                    top: 60,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    )),
                Positioned(
                    top: 60,
                    right: 20,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt_outlined,
                          color: Colors.black),
                      onPressed: () {},
                    )),
              ],
            ),
            const _ProductForm(),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton(
          child: const Icon(Icons.save_outlined),
          onPressed: () async {
            //Guardar Producto
            if (!productForm.isValidForm()) return;
            await productService.saveOrCreateProduct(productForm.product);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          decoration: _productformDecoration(),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: productForm.formKey,
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: product.nombre,
                onChanged: (value) => product.nombre = value,
                validator: (value) {
                  if (value == null || value.length < 1) {
                    return 'El nombre es obligatorio';
                  }
                },
                decoration: InputDecorations.authInputDecoration(
                    labelText: 'Nombre', hintText: 'Nombre del producto'),
              ),
              const SizedBox(height: 30),
              TextFormField(
                initialValue: '${product.precio}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,3}.?\d{0,3}'))
                ],
                onChanged: (value) {
                  if (double.tryParse(value) == null) {
                    product.precio = 0;
                  } else {
                    product.precio = double.parse(value);
                  }
                },
                decoration: InputDecorations.authInputDecoration(
                    labelText: 'Precio:', hintText: '\$150'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              SwitchListTile.adaptive(
                  value: product.disponible,
                  title: const Text('Disponible'),
                  activeColor: Colors.indigo,
                  onChanged: (value) => productForm.updateAvailability(value)),
              const SizedBox(height: 30),
            ]),
          )),
    );
  }

  BoxDecoration _productformDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              bottomRight: const Radius.circular(25),
              bottomLeft: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 5),
                blurRadius: 5)
          ]);
}
