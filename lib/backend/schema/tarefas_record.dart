import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'tarefas_record.g.dart';

abstract class TarefasRecord
    implements Built<TarefasRecord, TarefasRecordBuilder> {
  static Serializer<TarefasRecord> get serializer => _$tarefasRecordSerializer;

  @nullable
  String get nome;

  @nullable
  int get status;

  @nullable
  String get descricao;

  @nullable
  DateTime get data;

  @nullable
  @BuiltValueField(wireName: 'criado_em')
  DateTime get criadoEm;

  @nullable
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(TarefasRecordBuilder builder) => builder
    ..nome = ''
    ..status = 0
    ..descricao = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('tarefas');

  static Stream<TarefasRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s)));

  static Future<TarefasRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s)));

  TarefasRecord._();
  factory TarefasRecord([void Function(TarefasRecordBuilder) updates]) =
      _$TarefasRecord;

  static TarefasRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference});
}

Map<String, dynamic> createTarefasRecordData({
  String nome,
  int status,
  String descricao,
  DateTime data,
  DateTime criadoEm,
}) =>
    serializers.toFirestore(
        TarefasRecord.serializer,
        TarefasRecord((t) => t
          ..nome = nome
          ..status = status
          ..descricao = descricao
          ..data = data
          ..criadoEm = criadoEm));
