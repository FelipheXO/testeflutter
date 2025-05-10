import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:teste_flutter/features/tables/stores/tables.stores.dart';
import 'package:teste_flutter/features/tables/widgets/tables_header.widget.dart';
import 'package:teste_flutter/features/tables/widgets/tables_list.widget.dart';

class TablesPage extends StatefulWidget {
  const TablesPage({super.key});

  @override
  State<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage> {
  final TablesStore tablesStore = GetIt.I<TablesStore>();
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TablesHeader(
          tableEntity: tablesStore.tables,
          onChanged: (p0) {
            search = p0 ?? "";
            setState(() {});
          },
        ),
        const Divider(),
        Observer(
          builder: (_) {
            final query = search.toLowerCase();
            final filteredTables = tablesStore.tables.where((table) {
              final matchesIdentification =
                  table.identification.toLowerCase().contains(query);
              final matchesCustomer = table.customers.any((customer) =>
                  customer.name.toLowerCase().contains(query) ||
                  customer.phone.toLowerCase().contains(query));
              return query.isEmpty || matchesIdentification || matchesCustomer;
            }).toList();
            return TablesList(tableEntity: filteredTables);
          },
        ),
      ],
    );
  }
}
