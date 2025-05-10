import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:teste_flutter/features/customers/stores/customers.store.dart';
import 'package:teste_flutter/features/tables/entities/table.entity.dart';
import 'package:teste_flutter/features/tables/widgets/customers_counter.widget.dart';
import 'package:teste_flutter/features/tables/widgets/table_model.widget.dart';
import 'package:teste_flutter/shared/widgets/search_input.widget.dart';
import 'package:teste_flutter/utils/extension_methos/material_extensions_methods.dart';

class TablesHeader extends StatelessWidget {
  const TablesHeader(
      {super.key, required this.onChanged, required this.tableEntity});
  final Function(String?) onChanged;
  final List<TableEntity> tableEntity;
  @override
  Widget build(BuildContext context) {
    final CustomersStore customersStore = GetIt.I<CustomersStore>();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Text(
              'Mesas',
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(width: 20),
            SearchInput(
              onChanged: onChanged,
            ),
            const SizedBox(width: 20),
            Observer(
              builder: (_) => CustomersCounter(
                  label: tableEntity
                      .expand((table) => table.customers)
                      .toSet()
                      .toList()
                      .length
                      .toString()),
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const TableModal(table: null),
                );
              },
              tooltip: 'Criar nova mesa',
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
