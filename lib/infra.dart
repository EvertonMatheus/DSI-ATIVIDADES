import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final dsiHelper = _DsiHelper();

class _DsiHelper {
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
              Navigator.of(context).pop();
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
