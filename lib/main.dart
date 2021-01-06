import 'package:dsi_app/aluno_widgets.dart';
import 'package:dsi_app/constants.dart';
import 'package:dsi_app/home.dart';
import 'package:dsi_app/login.dart';
import 'package:dsi_app/pessoa_widgets.dart';
import 'package:dsi_app/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dsi_app/professor_widgets.dart';

void main() {
  //TIP a linha abaixo precisa ser chamada antes de montar o app,
  //devido ao carregamento do firebase.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DSIApp());
}

class DSIApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return _buildError(context);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildApp(context);
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return _buildLoading(context);
      },
    );
  }

  Widget _buildApp(context) {
    return MaterialApp(
      title: Constants.appName,
      theme: _buildThemeData(),
      initialRoute: '/',
      routes: _buildRoutes(context),
    );
  }

  Widget _buildError(context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: Text(
          'Erro ao carregar os dados do App.\n'
          'Tente novamente mais tarde.,',
          style: TextStyle(
            color: Colors.red,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _buildLoading(context) {
    //TIP como o componente não está no contexto do app, já que este ainda não
    //foi criado, é preciso colocar o componente dentro do Directionality.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            Text(
              'carregando...',
              style: TextStyle(
                color: Constants.colorGreenBSI1,
                fontSize: 16.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ThemeData _buildThemeData() {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primarySwatch: Colors.green,
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 22.0, fontStyle: FontStyle.italic),
        caption: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
        bodyText1: TextStyle(fontSize: 18.0),
        bodyText2: TextStyle(fontSize: 16.0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: Constants.defaultBorderRadius,
        ),
        contentPadding: Constants.insetsMedium,
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.green,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: Constants.defaultBorderRadius,
        ),
      ),
    );
  }

  _buildRoutes(context) {
    return {
      '/': (context) => LoginPage(),
      '/register': (context) => RegisterPage(),
      '/home': (context) => HomePage(),
      '/list_pessoa': (context) => ListPessoaPage(),
      '/maintain_pessoa': (context) => MaintainPessoaPage(),
      '/list_aluno': (context) => ListAlunoPage(),
      '/list_professor': (context) => ListprofessorPage(),
      '/maintain_aluno': (context) => MaintainAlunoPage(),
      '/maintain_professor': (context) => MaintainprofessorPage(),
    };
  }
}
