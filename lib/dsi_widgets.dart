import 'dart:async';
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

class DsiTitle extends StatelessWidget {
  final String title;
  DsiTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        '$title',
        style:
            Theme.of(context).textTheme.headline1.copyWith(color: Colors.white),
      ),
      height: 50.0,
      width: double.infinity,
      color: Theme.of(context).accentColor,
      alignment: Alignment.center,
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
      body: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            DsiTitle('${widget.title}'),
            //TIP sempre colocar o scroll dentro de um Expanded, para evitar
            // erro de overflow na tela.
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: Constants.insetsMedium,
                  child: Column(
                    children: <Widget>[
                      widget.body,
                      Constants.boxMediumHeight,
                      _buildFormButtons(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormButtons(context) {
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
              widget.onSave(context);
            },
          ),
        ),
        FlatButton(
          child: Text('Cancelar'),
          padding: Constants.insetsSmall,
          onPressed: () => dsiHelper.back(context),
        ),
      ],
    );
  }
}

typedef DsiFutureBuilderFunction<T> = Function(BuildContext, T);

class DsiFutureBuilder<T> extends StatefulWidget {
  final FutureOr<T> target;
  final DsiFutureBuilderFunction<T> builder;

  ///TIP é importante setar a chave para atualizar corretamente a tela ao
  ///remover ou alterar um componente.
  DsiFutureBuilder({Key key, this.target, this.builder}) : super(key: key);

  @override
  DsiFutureBuilderState<T> createState() => DsiFutureBuilderState<T>();
}

class DsiFutureBuilderState<T> extends State<DsiFutureBuilder<T>> {
  FutureOr<T> target;

  DsiFutureBuilderState();

  @override
  void initState() {
    super.initState();
    this.target = widget.target;
  }

  @override
  Widget build(BuildContext context) {
    if (!(target is Future)) {
      return widget.builder(context, target);
    }
    return FutureBuilder(
      future: (target as Future),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          //TIP apresenta o indicador de progresso enquanto carrega a página.
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Erro ao carregar os dados.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.0,
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Center(child: Text('Nenhum dado existente.'));
        }
        return widget.builder(context, snapshot.data);
      },
    );
  }
}

typedef DsilistDataBuilder<E> = FutureOr<List<FutureOr<E>>> Function();
typedef DsiListTileRemover<E> = Function(BuildContext context, E object);
typedef DsiListTileBuilder<E> = Widget Function(BuildContext context, E object);
typedef DsiFloatingActionButtonBuilder = FloatingActionButton Function(
    BuildContext context);

class DsiListPageState<E, T extends StatefulWidget> extends State<T> {
  String title;
  FutureOr<List<FutureOr<E>>> listData;
  DsilistDataBuilder<E> listDataBuilder;
  DsiListTileRemover<E> remover;
  DsiListTileBuilder<E> builder;
  DsiFloatingActionButtonBuilder floatingActionButtonBuilder;

  DsiListPageState(
      {this.title,
      this.listDataBuilder,
      this.remover,
      this.builder,
      this.floatingActionButtonBuilder});

  @override
  void initState() {
    super.initState();
    //TIP a atualização dos objetos que são carregados na lista precisa ser
    // feita no método initState. Caso fosse feita no construtor, ao exibir
    // a lista após atualizar um item, a lista não seria atualizada.
    // Todos os widgets stateful devem inicializar os valores de seus atributos
    // neste método e não no construtor ou no build.
    listData = listDataBuilder();
  }

  @override
  Widget build(BuildContext context) {
    return DsiScaffold(
      floatingActionButton: floatingActionButtonBuilder?.call(context),
      body: Builder(
        builder: (context) {
          return Column(
            children: <Widget>[
              DsiTitle(title),
              //TIP: Se não utilizar o Expanded, o FutureBuilder não irá
              // conseguir renderizar corretamente, dando um 'overflow' na
              // parte inferior da tela.
              Expanded(
                child: buildList(context),
              )
            ],
          );
        },
      ),
    );
  }

  Widget buildList(BuildContext context) {
    return DsiFutureBuilder<List<FutureOr<E>>>(
      key: UniqueKey(),
      target: listData,
      builder: (context, data) => ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: data.length,
        itemBuilder: (context, index) => buildItem(context, data[index]),
      ),
    );
  }

  Widget buildItem(BuildContext context, FutureOr<E> target) {
    return DsiFutureBuilder<E>(
      target: target,
      builder: (context, data) => Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          remover(context, data)
            ..then((value) {
              dsiHelper.showMessage(
                context: context,
                message: 'Item removido com sucesso.',
              );
              setState(() {
                listData = listDataBuilder();
              });
            })
            ..catchError((e) {
              dsiHelper.showMessage(context: context, message: e.toString());
              setState(() {});
            });
        },
        background: Container(
          color: Colors.red,
          child: Row(
            children: <Widget>[
              Constants.boxSmallWidth,
              Icon(Icons.delete, color: Colors.white),
              Spacer(),
              Icon(Icons.delete, color: Colors.white),
              Constants.boxSmallWidth,
            ],
          ),
        ),
        child: builder(context, data),
      ),
    );
  }
}
