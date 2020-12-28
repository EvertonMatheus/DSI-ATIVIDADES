import 'package:dsi_app/constants.dart';
import 'package:dsi_app/dsi_widgets.dart';
import 'package:dsi_app/infra.dart';
import 'package:dsi_app/pessoa.dart';
import 'package:flutter/material.dart';

/// A classe professor representa um professor do sistema e é uma subclasse de Pessoa.
/// Assim, tudo o que Pessoa possui, um professor também possui.
/// E todas as operações que podem ser feitas com uma pessoa, também podem ser
/// feitas com um professor. Assim, todos os métodos e funções que recebiam uma
/// Pessoa como parâmetro, também podem receber também um Professor.
class Professor extends Pessoa {
  String matricula;

  //Observe que o construtor de professor repassa alguns dos parâmetros recebidos
  //para o construtor da super classe (Pessoa).
  Professor({cpf, nome, endereco, this.matricula})
      : super(cpf: cpf, nome: nome, endereco: endereco);
}

var professorController = ProfessorController();

class ProfessorController {
  List<Professor> getAll() {
    return pessoaController.getAll().whereType<Professor>().toList();
  }

  Professor save(professor) {
    return pessoaController.save(professor);
  }

  bool remove(professor) {
    return pessoaController.remove(professor);
  }
}

class ListProfessorPage extends StatefulWidget {
  @override
  ListProfessorPageState createState() => ListProfessorPageState();
}

class ListProfessorPageState extends State<ListProfessorPage> {
  List<Professor> _professors = professorController.getAll();

  @override
  Widget build(BuildContext context) {
    return DsiScaffold(
      title: 'Listagem de Professores',
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => dsiHelper.go(context, '/maintain_professor'),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        // physics: NeverScrollableScrollPhysics(),
        itemCount: _professors.length,
        itemBuilder: _buildListTileProfessor,
      ),
    );
  }

  Widget _buildListTileProfessor(context, index) {
    var professor = _professors[index];
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        setState(() {
          professorController.remove(professor);
          _professors.remove(index);
        });
        dsiHelper.showMessage(
          context: context,
          message: '${professor.nome} foi removido.',
        );
      },
      background: Container(
        color: Colors.red,
        child: Row(
          children: <Widget>[
            Constants.spaceSmallWidth,
            Icon(Icons.delete, color: Colors.white),
            Spacer(),
            Icon(Icons.delete, color: Colors.white),
            Constants.spaceSmallWidth,
          ],
        ),
      ),
      child: ListTile(
        title: Text(professor.nome),
        subtitle: Column(
          children: <Widget>[
            Text('id. ${professor.id} (NUNCA APRENSETE O ID DE UM REGISTRO!)'),
            SizedBox(width: 8.0),
            Text('mat. ${professor.matricula}'),
          ],
        ),
        onTap: () =>
            dsiHelper.go(context, "/maintain_professor", arguments: professor),
      ),
    );
  }
}

class MaintainProfessorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Professor professor = dsiHelper.getRouteArgs(context);
    if (professor == null) {
      professor = Professor();
    }

    return DsiBasicFormPage(
      title: 'Professor',
      onSave: () {
        professorController.save(professor);
        dsiHelper.go(context, '/list_professor');
      },
      body: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: Constants.spaceSmallHeight.height,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'CPF*'),
            validator: (String value) {
              return value.isEmpty ? 'CPF inválido.' : null;
            },
            initialValue: professor.cpf,
            onSaved: (newValue) => professor.cpf = newValue,
          ),
          Constants.spaceSmallHeight,
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(labelText: 'Nome*'),
            validator: (String value) {
              return value.isEmpty ? 'Nome inválido.' : null;
            },
            initialValue: professor.nome,
            onSaved: (newValue) => professor.nome = newValue,
          ),
          Constants.spaceSmallHeight,
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(labelText: 'Endereço*'),
            validator: (String value) {
              return value.isEmpty ? 'Endereço inválido.' : null;
            },
            initialValue: professor.endereco,
            onSaved: (newValue) => professor.endereco = newValue,
          ),
          Constants.spaceSmallHeight,
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
