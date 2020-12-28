import 'package:dsi_app/constants.dart';
import 'package:dsi_app/dsi_widgets.dart';
import 'package:dsi_app/infra.dart';
import 'package:flutter/material.dart';

abstract class Pessoa {
  int id;
  String cpf, nome, endereco;
  Pessoa({this.id, this.cpf, this.nome, this.endereco});
}

var pessoaController = PessoaController();

class PessoaController {
  var _nextId = 1;
  var _pessoas = <Pessoa>[];

  List<Pessoa> getAll() {
    return _pessoas;
  }

  Pessoa getByCPF(String cpf) {
    for (Pessoa p in _pessoas) {
      if (p.cpf == cpf) return p;
    }
    return null;
  }

  void _validateOnSave(pessoa) {
    Pessoa p = getByCPF(pessoa.cpf);
    if (p != null && p.id != pessoa.id)
      throw Exception('Já existe uma pessoa com o cpf ${pessoa.cpf}.');
  }

  Pessoa save(pessoa) {
    _validateOnSave(pessoa);
    //se a pessoa não possui id, está inserindo.
    //caso contrário, está alterando.
    //na alteração, remove o elemento do índice e substitui pelo novo.
    if (pessoa.id == null) {
      pessoa.id = _nextId++;
      _pessoas.add(pessoa);
    } else {
      var idx = _pessoas.indexWhere((element) => element.id == pessoa.id);
      _pessoas.setRange(idx, idx + 1, [pessoa]);
    }
    return pessoa;
  }

  bool remove(pessoa) {
    var result = false;
    var idx = _pessoas.indexWhere((element) => element.id == pessoa.id);
    if (idx != -1) {
      result = true;
      _pessoas.removeAt(idx);
    }
    return result;
  }
}

class ListPessoaPage extends StatefulWidget {
  @override
  ListPessoaPageState createState() => ListPessoaPageState();
}

class ListPessoaPageState extends State<ListPessoaPage> {
  List<Pessoa> _pessoas = pessoaController.getAll();

  @override
  Widget build(BuildContext context) {
    return DsiScaffold(
      title: 'Listagem de Pessoas',
      body: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: _pessoas.length,
        itemBuilder: _buildListTilePessoa,
      ),
    );
  }

  Widget _buildListTilePessoa(context, index) {
    var pessoa = _pessoas[index];
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        setState(() {
          pessoaController.remove(pessoa);
          _pessoas.remove(index);
        });
        dsiHelper.showMessage(
          context: context,
          message: '${pessoa.nome} foi removido.',
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
        title: Text(pessoa.nome),
        subtitle: Text('${pessoa.endereco}'),
        onTap: () =>
            dsiHelper.go(context, "/maintain_pessoa", arguments: pessoa),
      ),
    );
  }
}

class MaintainPessoaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Pessoa pessoa = dsiHelper.getRouteArgs(context);
    //Não existe inserção de Pessoa. Apenas de aluno ou professor.
    return DsiBasicFormPage(
      title: 'Pessoa',
      onSave: () {
        pessoaController.save(pessoa);
        dsiHelper.go(context, '/list_pessoa');
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
            initialValue: pessoa.cpf,
            onSaved: (newValue) => pessoa.cpf = newValue,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(labelText: 'Nome*'),
            validator: (String value) {
              return value.isEmpty ? 'Nome inválido.' : null;
            },
            initialValue: pessoa.nome,
            onSaved: (newValue) => pessoa.nome = newValue,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(labelText: 'Endereço*'),
            validator: (String value) {
              return value.isEmpty ? 'Endereço inválido.' : null;
            },
            initialValue: pessoa.endereco,
            onSaved: (newValue) => pessoa.endereco = newValue,
          ),
        ],
      ),
    );
  }
}
