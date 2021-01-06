import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final DsiHelper dsiHelper = DsiHelper._();

class DsiHelper {
  DsiHelper._();

  Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double getScreenHeight(BuildContext context) {
    return getScreenSize(context).height;
  }

  double getScreenWidth(BuildContext context) {
    return getScreenSize(context).width;
  }

  void go(context, routeName, {arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  void back(context) {
    Navigator.pop(context);
  }

  void exit(context) {
    Navigator.pushNamedAndRemoveUntil(
        context, '/', (Route<dynamic> route) => false);
  }

  Object getRouteArgs(context) {
    return ModalRoute.of(context).settings.arguments;
  }

  void showMessage({
    context,
    message = 'Operação realizada com sucesso.',
  }) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void showAlert(
      {context,
      message = 'Operação realizada com sucesso.',
      title = 'Sucesso',
      onPressed}) {
    var dialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text('Fechar'),
          onPressed: () {
            if (onPressed == null) {
              Navigator.pop(context);
            } else {
              onPressed.call();
            }
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }
}

enum DsiRestMethod { GET, PUT, DELETE }

///TIP: para montar a URI usando o URI.https, o servidor precisa estar neste
///formato abaixo. Ou seja, não deve informar as barras ou o http ou https.
const default_server = 'dsi-app-6ed12.firebaseio.com';

const default_headers = {
  HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
};

final DsiRest dsiRest = DsiRest._();

class DsiRest {
  DsiRest._();

  bool isOK(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  bool isFail(http.Response response) {
    return !isOK(response);
  }

  ///TIP a palavra reservada 'await' só pode ser usada dentro de um
  ///método/função sincronizado. Ele indica que esta linha de código irá
  ///esperar até que o objeto embutido no 'Future' esteja disponível.
  ///Neste caso, irá esperar até que o response esteja disponível.
  ///Caso não fosse usado o 'await', o objeto não seria um http.Respose, mas
  ///um Future<http.Response>. Remova a palavra reservada e veja o
  ///comportamento do código.
  Future<T> call<T>(
      {String server = default_server,
      String path,
      Map<String, String> params,
      Map<String, String> headers = default_headers,
      Map<String, dynamic> body,
      Future<T> process(json)}) async {
    var uri = Uri.https(server, path, params);
    var response = body == null
        ? http.get(uri, headers: headers)
        : http.put(uri, body: jsonEncode(body), headers: headers);

    var res = await response;
    if (isOK(res)) {
      return res.body == null ? null : process(jsonDecode(res.body));
    } else {
      throw Exception('Falha ao chamar a api REST.');
    }
  }

  Future<bool> deleteJson(
      {String server = default_server,
      String path,
      Map<String, String> headers = default_headers}) async {
    var uri = Uri.https(server, path);
    var response = await http.delete(uri, headers: headers);
    return isOK(response);
  }
}
