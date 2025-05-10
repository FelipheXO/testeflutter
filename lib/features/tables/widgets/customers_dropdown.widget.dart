import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teste_flutter/features/customers/widgets/edit_customer_modal.widget.dart';
import 'package:teste_flutter/utils/constants/app_icons.constants.dart';

import '../../customers/entities/customer.entity.dart';

class CustomerDropdown extends StatefulWidget {
  final List<CustomerEntity> customers;
  final void Function(CustomerEntity) onSelected;
  final void Function(String) onCreateNew;

  const CustomerDropdown({
    super.key,
    required this.customers,
    required this.onSelected,
    required this.onCreateNew,
  });

  @override
  State<CustomerDropdown> createState() => _CustomerDropdownState();
}

class _CustomerDropdownState extends State<CustomerDropdown> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;

  List<CustomerEntity> _filtered = [];

  void _showOverlay() {
    _filtered = widget.customers
        .where((c) =>
            c.name.toLowerCase().contains(_controller.text.toLowerCase()))
        .toList();

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + renderBox.size.height,
        width: renderBox.size.width,
        child: Material(
          elevation: 4,
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              ListTile(
                leading: const Icon(Icons.person_add, color: Colors.green),
                title: const Text("Novo cliente",
                    style: TextStyle(color: Colors.green)),
                subtitle: Text(_controller.text),
                onTap: () {
                  _hideOverlay();
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return const Dialog(
                          backgroundColor: Colors.transparent,
                          child: EditCustomerModal());
                    },
                  );
                },
              ),
              ..._filtered.map((c) {
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(c.name),
                  subtitle: Text(c.phone),
                  onTap: () {
                    widget.onSelected(c);
                    _controller.text = c.name;
                    _hideOverlay();
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      }
    });

    _controller.addListener(() {
      if (_focusNode.hasFocus) {
        _overlayEntry?.remove();
        _showOverlay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          prefixIcon: Container(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              AppIcons.user,
            ),
          ),
          suffixIcon: Container(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              AppIcons.search,
            ),
          ),
          hintText: 'Pesquise por nome ou telefone',
          hintStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
