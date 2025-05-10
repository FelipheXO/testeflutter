// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:teste_flutter/features/tables/entities/table.entity.dart';

part 'tables.stores.g.dart';

class TablesStore = _TablesStoreBase with _$TablesStore;

abstract class _TablesStoreBase with Store {
  @observable
  ObservableList<TableEntity> tables = ObservableList<TableEntity>();

  @action
  void addTable(TableEntity table) {
    tables.add(table);
  }

  @action
  void removeTable(TableEntity table) {
    tables.removeWhere((t) => t.id == table.id);
  }

  @action
  void updateTable(TableEntity table) {
    final index = tables.indexWhere((t) => t.id == table.id);
    if (index != -1) {
      tables[index] = table;
    }
  }
}
