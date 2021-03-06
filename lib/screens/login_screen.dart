import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:productos_app/services/services.dart';
import '../ui/input_decoration.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
                Text('Login', style: Theme.of(context).textTheme.headline4),
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
                    Navigator.pushReplacementNamed(context, 'register'),
                child: Text(
                  'Crear una nueva cuenta',
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
                loginForm.email = value;
              },
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  labelText: 'Correo electr??nico',
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
                  labelText: 'Contrase??a',
                  hintText: 'Contrase??a1...',
                  prefixIcon: Icons.lock_outline),
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contrase??a debe ser de 6 caracteres';
              },
            ),
            SizedBox(height: size.height * 0.03),
            MaterialButton(
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      //Si el formulario es valido petici??n http.
                      if (!loginForm.isValidForm()) return;
                      final authService =
                          Provider.of<AuthService>(context, listen: false);
                      //Si es valido.
                      FocusScope.of(context).unfocus();
                      loginForm.isLoading = true;

                      //Petici??n http.
                      final String? errorMessage = await authService.loginUser(
                        loginForm.email,
                        loginForm.password,
                      );
                      if (errorMessage == null) {
                        Navigator.pushReplacementNamed(context, 'home');
                      } else {
                        //Mostrar error en pantalla.
                        print(errorMessage);
                        NotificationsService.showSnackbar(
                            'Error al iniciar sesi??n.');
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
