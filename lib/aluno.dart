import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsi_app/pessoa.dart';

/// A classe [Aluno] representa um aluno do sistema e possui uma instância da
/// classe [Pessoa]. Da forma que estava nos branches anteriores, a [Pessoa]
/// só poderia ser um aluno ou um professor. Este problema só pode ser resolvido
/// com o uso de composição ao invés de herança.
class Aluno {
  String id;
  String matricula;
  Pessoa pessoa;

  Aluno({this.id, this.matricula, this.pessoa});

  Aluno.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    matricula = json['matricula'];
  }

  Map<String, dynamic> toJson() => {'matricula': matricula};
}

AlunoController alunoController = AlunoController();

class AlunoController {
  CollectionReference alunos;

  AlunoController() {
    alunos = FirebaseFirestore.instance.collection('alunos');
  }

  DocumentReference getRef(String id) {
    return alunos.doc(id);
  }

  FutureOr<Aluno> fromJson(DocumentSnapshot snapshot) async {
    Map<String, dynamic> data = snapshot.data();
    Aluno aluno = Aluno.fromJson(data);
    aluno.id = snapshot.id;
    DocumentReference ref = data['pessoa'];
    aluno.pessoa = pessoaController.fromJson(await ref.get());
    return aluno;
  }

  Map<String, dynamic> toJson(Aluno aluno) {
    DocumentReference ref = pessoaController.getRef(aluno.pessoa.id);
    return aluno.toJson()..putIfAbsent('pessoa', () => ref);
  }

  FutureOr<List<FutureOr<Aluno>>> getAll() async {
    QuerySnapshot documents = await alunos.get();
    FutureOr<List<FutureOr<Aluno>>> result =
        documents.docs.map(fromJson).toList();
    return result;
  }

  FutureOr<Aluno> getById(String id) async {
    DocumentSnapshot doc = await alunos.doc(id).get();
    return fromJson(doc);
  }

  Future<void> remove(FutureOr<Aluno> aluno) async {
    Aluno a = await aluno;
    //TIP idealmente as duas linhas abaixo deveriam ser executadas
    //em uma única transação
    Future<void> result = alunos.doc(a.id).delete();
    pessoaController.remove(a.pessoa);
    return result;
  }

  Future<Aluno> save(FutureOr<Aluno> aluno) async {
    Aluno a = await aluno;
    a.pessoa = await pessoaController.save(a.pessoa);
    Map<String, dynamic> data = toJson(a);
    if (a.id == null) {
      DocumentReference ref = await alunos.add(data);
      return fromJson(await ref.get());
    } else {
      alunos.doc(a.id).update(data);
      return a;
    }
  }
}
