import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../ui/input_decoration.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: AuthBackground(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.3),
            CardContainer(
              child: Column(children: [
                SizedBox(height: size.height * 0.01),
                Text('Crear cuenta',
                    style: Theme.of(context).textTheme.headline4),
                SizedBox(height: size.height * 0.03),
                ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(),
                  child: const _LoginForm(),
                )
              ]),
            ),
            SizedBox(height: size.height * 0.05),
            TextButton(
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        Colors.indigo.withOpacity(0.1)),
                    shape: MaterialStateProperty.all(StadiumBorder())),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'login'),
                child: Text(
                  '¿Ya tienes una cuenta?',
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                )),
            SizedBox(height: size.height * 0.05),
          ],
        ),
      )),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    final size = MediaQuery.of(context).size;
    return Form(
        //Validaciones y manejo de referencia KEY.
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) {
                loginForm.nombre = value;
              },
              autocorrect: false,
              keyboardType: TextInputType.name,
              decoration: InputDecorations.authInputDecoration(
                  labelText: 'Usuario',
                  hintText: 'usuario',
                  prefixIcon: Icons.person),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El usuario es obligatorio';
                }
                if (value.trim().length < 4) {
                  return 'El usuario debe contener 4 letras como minimo';
                }
                // Return null if the entered username is valid
                return null;
              },
            ),
            SizedBox(height: size.height * 0.03),
            TextFormField(
              onChanged: (value) {
                loginForm.email = value;
              },
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  labelText: 'Correo electrónico',
                  hintText: 'correo@correos.com',
                  prefixIcon: Icons.alternate_email_sharp),
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El correo no es correcto';
              },
            ),
            SizedBox(height: size.height * 0.03),
            TextFormField(
              onChanged: (value) {
                loginForm.password = value;
              },
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  labelText: 'Contraseña',
                  hintText: 'Contraseña1...',
                  prefixIcon: Icons.lock_outline),
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe ser de 6 caracteres';
              },
            ),
            SizedBox(height: size.height * 0.03),
            MaterialButton(
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      //Si el formulario es valido petición http.
                      if (!loginForm.isValidForm()) return;
                      final authService =
                          Provider.of<AuthService>(context, listen: false);
                      //Si es valido.
                      FocusScope.of(context).unfocus();
                      loginForm.isLoading = true;

                      //Petición http.
                      final String? errorMessage = await authService.createUser(
                          loginForm.email,
                          loginForm.password,
                          loginForm.nombre);
                      if (errorMessage == null) {
                        Navigator.pushReplacementNamed(context, 'home');
                      } else {
                        //Mostrar error en pantalla.
                        print(errorMessage);
                        loginForm.isLoading = false;
                      }
                    },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(loginForm.isLoading ? 'Espere...' : 'Ingresar',
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ));
  }
}
