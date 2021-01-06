import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class Estado {
  static final Estado AC = Estado._('Acre', 'AC');
  static final Estado AL = Estado._('Alagoas', 'AL');
  static final Estado AP = Estado._('Amapa', 'AP');
  static final Estado AM = Estado._('Amazonas', 'AM');
  static final Estado BA = Estado._('Bahia', 'BA');
  static final Estado CE = Estado._('Ceará', 'CE');
  static final Estado DF = Estado._('Distrito Federal', 'DF');
  static final Estado ES = Estado._('Espírito Santo', 'ES');
  static final Estado GO = Estado._('Goias', 'GO');
  static final Estado MA = Estado._('Maranhão', 'MA');
  static final Estado MT = Estado._('Mato Grosso', 'MT');
  static final Estado MS = Estado._('Mato Grosso do Sul', 'MS');
  static final Estado MG = Estado._('Minas Gerais', 'MG');
  static final Estado PA = Estado._('Pará', 'PA');
  static final Estado PB = Estado._('Paraíba', 'PB');
  static final Estado PR = Estado._('Paraná', 'PR');
  static final Estado PE = Estado._('Pernambuco', 'PE');
  static final Estado PI = Estado._('Piauí', 'PI');
  static final Estado RJ = Estado._('Rio de Janeiro', 'RJ');
  static final Estado RN = Estado._('Rio Grande do Norte', 'RN');
  static final Estado RS = Estado._('Rio Grande do Sul', 'RS');
  static final Estado RO = Estado._('Rondônia', 'RO');
  static final Estado RR = Estado._('Roraima', 'RR');
  static final Estado SC = Estado._('Santa Catarina', 'SC');
  static final Estado SP = Estado._('São Paulo', 'SP');
  static final Estado SE = Estado._('Sergipe', 'SE');
  static final Estado TO = Estado._('Tocantins', 'TO');

  String nome, sigla;

  /// Construtor privado para evitar que instâncias de estado sejam
  /// criadas fora deste módulo
  Estado._(this.nome, this.sigla);

  static List<Estado> values() {
    return [
      AC,
      AL,
      AP,
      AM,
      BA,
      CE,
      DF,
      ES,
      GO,
      MA,
      MT,
      MS,
      MG,
      PA,
      PB,
      PR,
      PE,
      PI,
      RJ,
      RN,
      RS,
      RO,
      RR,
      SC,
      SP,
      SE,
      TO
    ];
  }

  static Estado getByNome(nome) {
    return values().firstWhere((element) => element.nome == nome);
  }

  static Estado getBySigla(sigla) {
    return values().firstWhere((element) => element.sigla == sigla);
  }

  static Estado getByIndex(idx) {
    return values()[idx];
  }
}

class Endereco {
  String logradouro, numero, bairro, cidade, cep;
  Estado estado = Estado.AC;

  Endereco(
      {this.logradouro,
      this.numero,
      this.bairro,
      this.cidade,
      this.estado,
      this.cep});

  //TIP observe que o estado é retornado pela sua sigla, uma vez que na
  //conversão do objeto para um objeto JSON, o que é salvo é a sigla. Veja que
  //no método toJson o que é incluído no mapa é a sigla.
  Endereco.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    logradouro = json['logradouro'];
    numero = json['numero'];
    bairro = json['bairro'];
    cidade = json['cidade'];
    estado = Estado.getBySigla(json['estado']);
    cep = json['cep'];
  }

  //TIP observe que não é necessário salvar todos os dados do estado, apenas
  //a sua sigla. No construtor, basta pegar a sigla salva, e recuperar o estado
  //equivalente pela sigla.
  Map<String, dynamic> toJson() => {
        'logradouro': logradouro,
        'numero': numero,
        'bairro': bairro,
        'cidade': cidade,
        'estado': estado.sigla,
        'cep': cep
      };
}

class Pessoa {
  String id, cpf, nome;
  Endereco endereco;
  Pessoa({this.id, this.cpf, this.nome, this.endereco}) {
    if (endereco == null) endereco = Endereco();
  }

  //TIP construtor 'fromJson' permite a construção de um objeto a partir de um
  //mapa que representa um objeto JSON.
  //Para maiores informações sobre JSON consulte:
  //https://pt.wikipedia.org/wiki/JSON
  //
  //Observe que ao criar a pessoa, a criação do objeto endereco é delegada para
  //a classe Endereco, seguindo o princípio do encapsulamento.
  Pessoa.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    cpf = json['cpf'];
    nome = json['nome'];
    endereco = Endereco.fromJson(json['endereco']);
  }

  //TIP este método converte o objeto atual para um mapa que representa um
  //objeto JSON. Observe que a conversão do objeto endereço é delegada para
  //o próprio objeto, seguindo o princípio do encapsulamento.
  Map<String, dynamic> toJson() => {
        'cpf': cpf,
        'nome': nome,
        'endereco': endereco.toJson(),
      };
}

PessoaController pessoaController = PessoaController();

///Classe abstrata para o controlador de pessoa;
///Apenas esta classe é visível externamente.
///As implementações específicas do controlador, são internas a este módulo.
class PessoaController {
  CollectionReference pessoas;

  PessoaController() {
    pessoas = FirebaseFirestore.instance.collection('pessoas');
  }

  DocumentReference getRef(String id) {
    return pessoas.doc(id);
  }

  FutureOr<Pessoa> fromJson(DocumentSnapshot snapshot) {
    return Pessoa.fromJson(snapshot.data())..id = snapshot.id;
  }

  Map<String, dynamic> toJson(Pessoa pessoa) => pessoa.toJson();

  FutureOr<List<FutureOr<Pessoa>>> getAll() async {
    QuerySnapshot documents = await pessoas.get();
    return documents.docs.map(fromJson).toList();
  }

  FutureOr<Pessoa> getById(String id) async {
    DocumentSnapshot doc = await pessoas.doc(id).get();
    return fromJson(doc);
  }

  Future<void> remove(FutureOr<Pessoa> pessoa) async {
    Pessoa p = await pessoa;
    Query query = FirebaseFirestore.instance
        .collection("alunos")
        .where("pessoa", isEqualTo: getRef(p.id));
    QuerySnapshot snapshot = await query.get();
    if (snapshot.size > 0)
      throw Exception(
          'Não é possível remover a pessoa, pois existe um aluno associado '
          'a ela. Caso deseje, remova o aluno.');
    else
      return pessoas.doc(p.id).delete();
  }

  Future<Pessoa> save(FutureOr<Pessoa> pessoa) async {
    Pessoa p = await pessoa;
    Map<String, dynamic> data = toJson(p);
    if (p.id == null) {
      DocumentReference ref = await pessoas.add(data);
      return fromJson(await ref.get());
    } else {
      pessoas.doc(p.id).update(data);
      return pessoa;
    }
  }
}
