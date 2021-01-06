import 'package:dsi_app/professor.dart';
import 'package:dsi_app/constants.dart';
import 'package:dsi_app/dsi_widgets.dart';
import 'package:dsi_app/infra.dart';
import 'package:dsi_app/pessoa.dart';
import 'package:dsi_app/pessoa_widgets.dart';
import 'package:flutter/material.dart';

class ListprofessorPage extends StatefulWidget {
  @override
  DsiListPageState<Professor, ListprofessorPage> createState() =>
      DsiListPageState<Professor, ListprofessorPage>(
        title: 'Lista de Professores',
        listDataBuilder: () => professorController.getAll(),
        remover: (context, object) => professorController.remove(object),
        builder: (context, object) {
          return DsiFutureBuilder(
            key: UniqueKey(),
            target: object,
            builder: (context, professor) => ListTile(
              title: Text(professor.pessoa.nome),
              subtitle: Text('mat. ${professor.matricula}'),
              onTap: () => dsiHelper.go(context, "/maintain_professor",
                  arguments: professor),
            ),
          );
        },
        floatingActionButtonBuilder: (context) => FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => dsiHelper.go(context, '/maintain_professor'),
        ),
      );
}

class MaintainprofessorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Professor professor = dsiHelper.getRouteArgs(context);
    if (professor == null) {
      professor = Professor();
      professor.pessoa = Pessoa();
    }

    return DsiBasicFormPage(
      title: 'Professor',
      onSave: (context) {
        professorController.save(professor).then((value) {
          dsiHelper.go(context, '/list_professor');
        });
      },
      body: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: Constants.boxSmallHeight.height,
        children: <Widget>[
          MaintainPessoaBody(professor.pessoa),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Matrícula*'),
            validator: (String value) {
              return value.isEmpty ? 'Matrícula inválida.' : null;
            },
            initialValue: professor.matricula,
            onSaved: (newValue) => professor.matricula = newValue,
          ),
        ],
      ),
    );
  }
}
