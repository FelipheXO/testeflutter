import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:teste_flutter/features/customers/entities/customer.entity.dart';
import 'package:teste_flutter/features/customers/stores/customers.store.dart';
import 'package:teste_flutter/features/tables/entities/table.entity.dart';
import 'package:teste_flutter/features/tables/stores/tables.stores.dart';
import 'package:teste_flutter/features/tables/widgets/card_customers.widget.dart';
import 'package:teste_flutter/features/tables/widgets/customers_dropdown.widget.dart';
import 'package:teste_flutter/shared/widgets/modal.widget.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:teste_flutter/shared/widgets/primary_button.widget.dart';
import 'package:teste_flutter/shared/widgets/secondary_button.widget.dart';

class TableModal extends StatefulWidget {
  final TableEntity? table;

  const TableModal({Key? key, this.table}) : super(key: key);

  @override
  _TableModalState createState() => _TableModalState();
}

class _TableModalState extends State<TableModal> {
  final _formKey = GlobalKey<FormState>();
  late List<CustomerEntity> localCustomers;
  late TextEditingController identificationController;
  late TextEditingController quantityController;
  final CustomersStore customersStore = GetIt.I<CustomersStore>();
  final TablesStore tablesStore = GetIt.I<TablesStore>();
  late TableEntity currentTable;

  @override
  void initState() {
    super.initState();
    currentTable = widget.table ??
        TableEntity(
          id: DateTime.now().millisecondsSinceEpoch,
          identification: '',
          customers: [],
        );

    localCustomers = widget.table?.customers ?? [];
    identificationController =
        TextEditingController(text: widget.table?.identification ?? '');
    quantityController =
        TextEditingController(text: localCustomers.length.toString());
  }

  @override
  void dispose() {
    identificationController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void handleSave() {
    if (_formKey.currentState?.validate() == true &&
        localCustomers.isNotEmpty) {
      var allTableCustomer = localCustomers.where((x) => x.id != 0).toList();
      var unSelectedClient = localCustomers.where((x) => x.id == 0).toList();
      // ignore: unused_local_variable
      for (var x in unSelectedClient) {
        allTableCustomer.add(
          CustomerEntity(
            id: allTableCustomer.length + 1,
            name: 'Cliente ${allTableCustomer.length + 1}',
            phone: 'Não informado',
          ),
        );
      }

      final updatedTable = TableEntity(
        id: currentTable.id,
        identification: identificationController.text,
        customers: allTableCustomer,
      );

      if (widget.table != null) {
        tablesStore.updateTable(updatedTable);
      } else {
        tablesStore.addTable(updatedTable);
      }
      Navigator.of(context).pop();
    } else if (localCustomers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione pelo menos um cliente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.table == null;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Form(
        key: _formKey,
        child: Modal(
          width: 400,
          titleWidget: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  text: isNew ? 'Criar nova mesa' : 'Editar informações da ',
                ),
                if (!isNew && widget.table != null)
                  TextSpan(
                    text: widget.table!.identification,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16),
                  ),
              ],
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          contentCrossAxisAlignment: CrossAxisAlignment.start,
          content: [
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  TextFormField(
                    controller: identificationController,
                    decoration: const InputDecoration(
                        labelText: 'Identificação da mesa'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe a identificação da mesa';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Informação temporária para ajudar na identificação do cliente.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
                width: double.infinity, height: 1, color: Colors.grey[300]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Clientes nesta conta",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Associe os clientes aos pedidos para salvar o pedido no histórico do cliente, pontuar no fidelidade e fazer pagamentos no fiado.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: quantityController,
                          decoration: const InputDecoration(
                              labelText: 'Quantidade de pessoas'),
                          readOnly: true,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      IconButton(
                        style: ButtonStyle(
                            side: WidgetStateProperty.all(BorderSide.none)),
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (localCustomers.isNotEmpty) {
                            setState(() {
                              localCustomers.removeLast();
                              quantityController.text =
                                  localCustomers.length.toString();
                            });
                          }
                        },
                      ),
                      IconButton(
                        style: ButtonStyle(
                            side: WidgetStateProperty.all(BorderSide.none)),
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            localCustomers.add(CustomerEntity(
                              id: 0,
                              name: 'Cliente ${localCustomers.length + 1}',
                              phone: 'Não informado',
                            ));
                            quantityController.text =
                                localCustomers.length.toString();
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Observer(
                    builder: (_) {
                      return Column(
                        children: localCustomers.asMap().entries.map((entry) {
                          final index = entry.key;
                          final c = entry.value;
                          if (c.id != 0) {
                            return CardCustomer(customerEntity: c);
                          } else {
                            return CustomerDropdown(
                              customers: customersStore.customers
                                  .where((c) => !localCustomers
                                      .any((lc) => lc.id == c.id))
                                  .toList(),
                              onSelected: (c) {
                                localCustomers[index] = c;
                                setState(() {});
                              },
                              onCreateNew: (name) {
                                final newCustomer = CustomerEntity(
                                  id: DateTime.now().millisecondsSinceEpoch,
                                  name: name,
                                  phone: '',
                                );
                                customersStore.addCustomer(newCustomer);
                                localCustomers[index] = newCustomer;
                                setState(() {});
                              },
                            );
                          }
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
          actions: [
            SecondaryButton(
                onPressed: () => Navigator.of(context).pop(), text: 'Cancelar'),
            PrimaryButton(onPressed: handleSave, text: 'Salvar'),
          ],
        ),
      ),
    );
  }
}
