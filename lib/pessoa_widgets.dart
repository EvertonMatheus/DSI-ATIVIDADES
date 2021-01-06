import 'package:dsi_app/constants.dart';
import 'package:dsi_app/dsi_widgets.dart';
import 'package:dsi_app/infra.dart';
import 'package:dsi_app/pessoa.dart';
import 'package:flutter/material.dart';

class ListPessoaPage extends StatefulWidget {
  @override
  DsiListPageState<Pessoa, ListPessoaPage> createState() =>
      DsiListPageState<Pessoa, ListPessoaPage>(
        title: 'Lista de Pessoas',
        listDataBuilder: () => pessoaController.getAll(),
        remover: (context, object) => pessoaController.remove(object),
        builder: (context, object) {
          return DsiFutureBuilder(
            key: UniqueKey(),
            target: object,
            builder: (context, pessoa) => ListTile(
              title: Text(pessoa.nome),
              subtitle: Text(
                  '${pessoa.endereco.cidade} - ${pessoa.endereco.estado.sigla}'),
              onTap: () =>
                  dsiHelper.go(context, "/maintain_pessoa", arguments: pessoa),
            ),
          );
        },
        floatingActionButtonBuilder: (context) => FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => dsiHelper.go(context, '/maintain_pessoa'),
        ),
      );
}

class MaintainPessoaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Pessoa pessoa = dsiHelper.getRouteArgs(context);
    if (pessoa == null) {
      pessoa = Pessoa();
    }

    return DsiBasicFormPage(
      title: 'Pessoa',
      onSave: (context) {
        pessoaController.save(pessoa).then((value) {
          dsiHelper.go(context, '/list_pessoa');
        });
      },
      body: MaintainPessoaBody(pessoa),
    );
  }
}

class MaintainPessoaBody extends StatefulWidget {
  Pessoa pessoa;

  MaintainPessoaBody(this.pessoa);

  @override
  MaintainPessoaBodyState createState() => MaintainPessoaBodyState();
}

class MaintainPessoaBodyState extends State<MaintainPessoaBody> {
  Pessoa pessoa;

  @override
  void initState() {
    super.initState();
    pessoa = widget.pessoa;
    if (pessoa == null) pessoa = Pessoa();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: Constants.boxSmallHeight.height,
      children: <Widget>[
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
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'CPF*'),
          validator: (String value) {
            return value.isEmpty ? 'CPF inválido.' : null;
          },
          initialValue: pessoa.cpf,
          onSaved: (newValue) => pessoa.cpf = newValue,
        ),
        _buildEndereco(context, pessoa.endereco),
      ],
    );
  }

  _buildEndereco(context, Endereco endereco) {
    //TIP a classe [BorderSide] é usada na renderização da borda do container.
    //por padrão, a largura da borda é definida como 1.0. Assim, é preciso dar
    //uma margem de 1.0 para ter espaço de renderizar a borda.

    //TIP o component Stack é usado para sobrepor componentes. Ele é bastante
    //usado para a criação de uma interface mais amigável. Neste caso, estamos
    //sobrepondo um label sobre a borda de um container. Note que o label tem
    //que ser incluído depois, senão a borda passaria por cima do label e não
    //o inverso.
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            top: Constants.spaceSmall,
            bottom: Constants.spaceSmall,
          ),
          padding: Constants.insetsMedium,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Theme.of(context).textTheme.caption.color,
            ),
            borderRadius: Constants.defaultBorderRadius,
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: Constants.boxSmallHeight.height,
            children: _buildEnderecoFields(context, endereco),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: Container(
            margin: EdgeInsets.only(left: Constants.spaceSmall),
            padding: EdgeInsets.only(
              left: Constants.spaceSmall,
              right: Constants.spaceSmall,
            ),
            color: Colors.white,
            child: Text(
              'Endereço*',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ),
      ],
    );
  }

  _buildEnderecoFields(context, Endereco endereco) {
    //TIP observe o uso do DropdownButtonFormField para o campo de estado.
    //este componente precisa tanto do onChanged quanto do onSaved. O onChanged
    //não precisa de nenhuma implementação específica no nosso caso, já que a
    //alteração só precisa ocorrer quando o usuário salva o formulário.
    return <Widget>[
      TextFormField(
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'CEP*'),
        validator: (String value) {
          return value.isEmpty ? 'CEP inválido.' : null;
        },
        initialValue: endereco.cep,
        onSaved: (newValue) => endereco.cep = newValue,
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(labelText: 'Logradouro*'),
        validator: (String value) {
          return value.isEmpty ? 'Logradouro inválido.' : null;
        },
        initialValue: endereco.logradouro,
        onSaved: (newValue) => endereco.logradouro = newValue,
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(labelText: 'Número'),
        initialValue: endereco.numero,
        onSaved: (newValue) => endereco.numero = newValue,
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(labelText: 'Bairro*'),
        validator: (String value) {
          return value.isEmpty ? 'Bairro inválido.' : null;
        },
        initialValue: endereco.bairro,
        onSaved: (newValue) => endereco.bairro = newValue,
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(labelText: 'Cidade*'),
        validator: (String value) {
          return value.isEmpty ? 'Cidade inválida.' : null;
        },
        initialValue: endereco.cidade,
        onSaved: (newValue) => endereco.cidade = newValue,
      ),
      DropdownButtonFormField(
        decoration: const InputDecoration(labelText: 'Estado*'),
        items: Estado.values().map<DropdownMenuItem<Estado>>((estado) {
          return DropdownMenuItem<Estado>(
            value: estado,
            child: Text(estado.nome),
          );
        }).toList(),
        value: endereco.estado,
        onChanged: (value) {},
        onSaved: (newValue) => endereco.estado = newValue,
      ),
    ];
  }
}
