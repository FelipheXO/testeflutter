import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:teste_flutter/features/tables/entities/table.entity.dart';
import 'package:teste_flutter/features/tables/widgets/table_card.widget.dart';

class TablesList extends StatelessWidget {
  const TablesList({super.key, required this.tableEntity});
  final List<TableEntity> tableEntity;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Observer(
        builder: (_) => Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              tableEntity.map((table) => TableCard(table: table)).toList(),
        ),
      ),
    );
  }
}
