import 'package:dsi_app/aluno.dart';
import 'package:dsi_app/constants.dart';
import 'package:dsi_app/dsi_widgets.dart';
import 'package:dsi_app/infra.dart';
import 'package:dsi_app/pessoa.dart';
import 'package:dsi_app/pessoa_widgets.dart';
import 'package:flutter/material.dart';

class ListAlunoPage extends StatefulWidget {
  @override
  DsiListPageState<Aluno, ListAlunoPage> createState() =>
      DsiListPageState<Aluno, ListAlunoPage>(
        title: 'Lista de Alunos',
        listDataBuilder: () => alunoController.getAll(),
        remover: (context, object) => alunoController.remove(object),
        builder: (context, object) {
          return DsiFutureBuilder(
            key: UniqueKey(),
            target: object,
            builder: (context, aluno) => ListTile(
              title: Text(aluno.pessoa.nome),
              subtitle: Text('mat. ${aluno.matricula}'),
              onTap: () =>
                  dsiHelper.go(context, "/maintain_aluno", arguments: aluno),
            ),
          );
        },
        floatingActionButtonBuilder: (context) => FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => dsiHelper.go(context, '/maintain_aluno'),
        ),
      );
}

class MaintainAlunoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Aluno aluno = dsiHelper.getRouteArgs(context);
    if (aluno == null) {
      aluno = Aluno();
      aluno.pessoa = Pessoa();
    }

    return DsiBasicFormPage(
      title: 'Aluno',
      onSave: (context) {
        alunoController.save(aluno).then((value) {
          dsiHelper.go(context, '/list_aluno');
        });
      },
      body: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: Constants.boxSmallHeight.height,
        children: <Widget>[
          MaintainPessoaBody(aluno.pessoa),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Matrícula*'),
            validator: (String value) {
              return value.isEmpty ? 'Matrícula inválida.' : null;
            },
            initialValue: aluno.matricula,
            onSaved: (newValue) => aluno.matricula = newValue,
          ),
        ],
      ),
    );
  }
}
