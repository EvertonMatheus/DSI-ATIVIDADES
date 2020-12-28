import 'package:dsi_app/constants.dart';
import 'package:dsi_app/dsi_widgets.dart';
import 'package:dsi_app/infra.dart';
import 'package:dsi_app/pessoa.dart';
import 'package:flutter/material.dart';

/// A classe aluno representa um aluno do sistema e é uma subclasse de Pessoa.
/// Assim, tudo o que Pessoa possui, um aluno também possui.
/// E todas as operações que podem ser feitas com uma pessoa, também podem ser
/// feitas com um aluno. Assim, todos os métodos e funções que recebiam uma
/// Pessoa como parâmetro, também podem receber também um Aluno.
class Aluno extends Pessoa {
  String matricula;

  //Observe que o construtor de aluno repassa alguns dos parâmetros recebidos
  //para o construtor da super classe (Pessoa).
  Aluno({cpf, nome, endereco, this.matricula})
      : super(cpf: cpf, nome: nome, endereco: endereco);
}

var alunoController = AlunoController();

class AlunoController {
  List<Aluno> getAll() {
    return pessoaController.getAll().whereType<Aluno>().toList();
  }

  Aluno save(aluno) {
    return pessoaController.save(aluno);
  }

  bool remove(aluno) {
    return pessoaController.remove(aluno);
  }
}

class ListAlunoPage extends StatefulWidget {
  @override
  ListAlunoPageState createState() => ListAlunoPageState();
}

class ListAlunoPageState extends State<ListAlunoPage> {
  List<Aluno> _alunos = alunoController.getAll();

  @override
  Widget build(BuildContext context) {
    return DsiScaffold(
      title: 'Listagem de Alunos',
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => dsiHelper.go(context, '/maintain_aluno'),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        // physics: NeverScrollableScrollPhysics(),
        itemCount: _alunos.length,
        itemBuilder: _buildListTileAluno,
      ),
    );
  }

  Widget _buildListTileAluno(context, index) {
    var aluno = _alunos[index];
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        setState(() {
          alunoController.remove(aluno);
          _alunos.remove(index);
        });
        dsiHelper.showMessage(
          context: context,
          message: '${aluno.nome} foi removido.',
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
        title: Text(aluno.nome),
        subtitle: Column(
          children: <Widget>[
            Text('id. ${aluno.id} (NUNCA APRENSETE O ID DE UM REGISTRO!)'),
            SizedBox(width: 8.0),
            Text('mat. ${aluno.matricula}'),
          ],
        ),
        onTap: () => dsiHelper.go(context, "/maintain_aluno", arguments: aluno),
      ),
    );
  }
}

class MaintainAlunoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Aluno aluno = dsiHelper.getRouteArgs(context);
    if (aluno == null) {
      aluno = Aluno();
    }

    return DsiBasicFormPage(
      title: 'Aluno',
      onSave: () {
        alunoController.save(aluno);
        dsiHelper.go(context, '/list_aluno');
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
            initialValue: aluno.cpf,
            onSaved: (newValue) => aluno.cpf = newValue,
          ),
          Constants.spaceSmallHeight,
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(labelText: 'Nome*'),
            validator: (String value) {
              return value.isEmpty ? 'Nome inválido.' : null;
            },
            initialValue: aluno.nome,
            onSaved: (newValue) => aluno.nome = newValue,
          ),
          Constants.spaceSmallHeight,
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(labelText: 'Endereço*'),
            validator: (String value) {
              return value.isEmpty ? 'Endereço inválido.' : null;
            },
            initialValue: aluno.endereco,
            onSaved: (newValue) => aluno.endereco = newValue,
          ),
          Constants.spaceSmallHeight,
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
