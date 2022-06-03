import 'package:flutter/material.dart';
import 'package:productos_app/widgets/widgets.dart';

import '../ui/input_decoration.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(),
                Positioned(
                    top: 60,
                    left: 20,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    )),
                Positioned(
                    top: 60,
                    right: 20,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt_outlined,
                          color: Colors.white),
                      onPressed: () {},
                    )),
              ],
            ),
            _ProductForm(),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton(
          child: Icon(Icons.save_outlined),
          onPressed: () {},
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          decoration: _productformDecoration(),
          child: Form(
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecorations.authInputDecoration(
                    labelText: 'Nombre', hintText: 'Nombre del producto'),
              ),
              const SizedBox(height: 30),
              TextFormField(
                decoration: InputDecorations.authInputDecoration(
                    labelText: 'Precio:', hintText: '\$150'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              SwitchListTile.adaptive(
                  value: true,
                  title: Text('Disponible'),
                  activeColor: Colors.indigo,
                  onChanged: (value) {}),
              SizedBox(height: 30),
            ]),
          )),
    );
  }

  BoxDecoration _productformDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: const Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 5),
                blurRadius: 5)
          ]);
}
