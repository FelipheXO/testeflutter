import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teste_flutter/features/customers/entities/customer.entity.dart';
import 'package:teste_flutter/utils/constants/app_icons.constants.dart';

class CardCustomer extends StatelessWidget {
  const CardCustomer({super.key, required this.customerEntity});
  final CustomerEntity customerEntity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0),
          borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            SvgPicture.asset(
              AppIcons.user,
              width: 14,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customerEntity.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    customerEntity.phone,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              customerEntity.id != 0 && customerEntity.phone == "Não informado"
                  ? AppIcons.search
                  : AppIcons.linkBroken,
              width: 14,
            ),
          ],
        ),
      ),
    );
  }
}
