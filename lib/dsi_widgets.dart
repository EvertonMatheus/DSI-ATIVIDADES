import 'dart:math';

import 'package:dsi_app/constants.dart';
import 'package:dsi_app/infra.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Este Scaffold é customizado para incluir o 'body' dentro de um scrollview,
/// evitando o overflow da tela, em telas maiores que o tamanho da tela do
/// aparelho. Esta primeira implementação considera apenas o Scaffold com o
/// parâmetro 'body'
class DsiScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget floatingActionButton;
  final bool showAppBar;

  //Na definição do parâmetro {@required this.body}, as chaves indicam que o
  //parâmetro é nominal (named parameter) e a anotação @required indica que o
  //parâmetro é obrigatório.
  DsiScaffold(
      {@required this.body,
      this.title,
      this.floatingActionButton,
      this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: _buildSideMenu(context),
      body: this.body,
      floatingActionButton: this.floatingActionButton,
    );
  }

  DrawerHeader _buildSideMenuHeader(context, themeData) {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [themeData.backgroundColor, themeData.primaryColor],
          transform: GradientRotation(pi / 2.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Image(
              image: Images.bsiLogo,
              height: 36.0,
              alignment: Alignment.bottomCenter,
              color: Constants.colorGreenBSI2,
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Text(
            'DSI App',
            style: themeData.textTheme.headline1.copyWith(
              fontSize: 50.0,
              fontWeight: FontWeight.bold,
              color: Constants.colorGreenBSI3,
            ),
          ),
          Spacer(
            flex: 3,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '''por Gabriel Alves\n'''
              '''contato: gabriel.alves@ufrpe.br''',
              textAlign: TextAlign.right,
              style: themeData.textTheme.caption.copyWith(
                fontSize: 12.0,
                color: Constants.colorGreenBSI2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Drawer _buildSideMenu(context) {
    var themeData = Theme.of(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          _buildSideMenuHeader(context, themeData),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => dsiHelper.go(context, '/home'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Pessoas'),
            onTap: () => dsiHelper.go(context, '/list_pessoa'),
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Alunos'),
            onTap: () => dsiHelper.go(context, '/list_aluno'),
          ),
          ListTile(
            leading: Icon(Icons.school),
            title: Text('Professores'),
            onTap: () => dsiHelper.go(context, '/list_professor'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
            onTap: () => dsiHelper.exit(context),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(context) {
    if (!showAppBar) return null;
    //quando informa o drawer do scaffold, não se informa o leading do AppBar.
    return AppBar(
      title: title != null ? Text(title) : null,
      actions: <Widget>[
        IconButton(
          onPressed: () => dsiHelper.showMessage(
            context: context,
            message: 'Falta implementar',
          ),
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () => dsiHelper.showMessage(
            context: context,
            message: 'Falta implementar',
          ),
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
        ),
        PopupMenuButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onSelected: (value) => {
            if (value == 'sair')
              dsiHelper.exit(context)
            else if (value == 'pref')
              dsiHelper.showAlert(
                context: context,
                message: 'Falta implementar',
              )
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            PopupMenuItem(
              child: Text('Preferências'),
              value: 'pref',
            ),
            PopupMenuItem(
              child: Text('Sair'),
              value: 'sair',
            ),
          ],
        ),
      ],
    );
  }
}

class DsiBasicFormPage extends StatefulWidget {
  final String title;
  final onSave;
  final Widget body;
  final hideButtons;
  DsiBasicFormPage(
      {@required this.title,
      @required this.body,
      this.onSave,
      this.hideButtons = false});

  @override
  DsiBasicFormPageState createState() => DsiBasicFormPageState();
}

class DsiBasicFormPageState<T> extends State<DsiBasicFormPage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DsiScaffold(
      title: widget.title,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: Constants.paddingMedium,
            child: Column(
              children: <Widget>[
                Constants.spaceMediumHeight,
                widget.body,
                Constants.spaceMediumHeight,
                _buildFormButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormButtons() {
    if (widget.hideButtons) return null;

    return Column(
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: RaisedButton(
            child: Text('Salvar'),
            onPressed: () {
              if (!formKey.currentState.validate()) return;
              setState(() {
                formKey.currentState.save();
              });
              widget.onSave.call();
            },
          ),
        ),
        FlatButton(
          child: Text('Cancelar'),
          padding: Constants.paddingSmall,
          onPressed: () => dsiHelper.back(context),
        ),
      ],
    );
  }
}
