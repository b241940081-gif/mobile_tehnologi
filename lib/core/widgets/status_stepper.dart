import 'package:flutter/material.dart';

import '../../data/mock_orders.dart';

class StatusStepper extends StatelessWidget {
  final OrderStatus currentStatus;

  const StatusStepper({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final statuses = OrderStatus.values;

    return Column(
      children: List.generate(statuses.length, (index) {
        final status = statuses[index];
        final reached = index <= currentStatus.index;
        final isLast = index == statuses.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Icon(
                  reached
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked,
                  color: reached
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFCBD5E1),
                  size: 25,
                ),
                if (!isLast)
                  Container(
                    height: 30,
                    width: 2,
                    color: reached && index < currentStatus.index
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFE2E8F0),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  status.label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: reached ? FontWeight.w700 : FontWeight.w400,
                    color: reached
                        ? const Color(0xFF0F172A)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
