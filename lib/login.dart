import 'package:dsi_app/constants.dart';
import 'package:dsi_app/infra.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dsi_widgets.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DsiScaffold(
      showAppBar: false,
      body: SingleChildScrollView(
        child: Container(
          height: dsiHelper.getScreenHeight(context),
          child: Column(
            children: <Widget>[
              Spacer(),
              Image(
                image: Images.bsiLogo,
                height: 100,
              ),
              Constants.boxSmallHeight,
              LoginForm(),
              Spacer(),
              Padding(
                padding: Constants.insetsMedium,
                child: Text(
                  'App desenvolvido por Gabriel Alves para a disciplina de'
                  ' Desenvolvimento de Sistemas de Informação do BSI/UFRPE.',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(fontSize: 12),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  void _forgotPassword() {
    dsiHelper.showAlert(
      context: context,
      title: 'Warning',
      message: '''Falta implementar esta função.\n'''
          '''Agora é com você:\n'''
          '''Implemente uma tela para esta funcionalidade!''',
    );
  }

  void _login() {
    if (!_formKey.currentState.validate()) return;

    dsiHelper.go(context, '/home');
  }

  void _register() {
    dsiHelper.go(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: Constants.insetsMedium,
        child: Wrap(
          alignment: WrapAlignment.center,
          runSpacing: Constants.boxSmallHeight.height,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Login*'),
              validator: (String value) {
                return value.isEmpty ? 'Login inválido.' : null;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha*'),
              validator: (String value) {
                return value.isEmpty ? 'Senha inválida.' : null;
              },
            ),
            Container(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text('Esqueceu a senha?'),
                padding: Constants.insetsSmall.copyWith(top: 0.0),
                onPressed: _forgotPassword,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Login'),
                onPressed: _login,
              ),
            ),
            FlatButton(
              child: Text('Cadastre-se'),
              padding: Constants.insetsSmall,
              onPressed: _register,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFlatButton(BuildContext context, String text, var onPressed) {
    return SizedBox.expand(
      child: FlatButton(
        color: Theme.of(context).buttonColor,
        child: Text(text),
        onPressed: _login,
      ),
    );
  }
}
