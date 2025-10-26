import 'package:flutter/material.dart';
import '../../models/reservation.dart';

class DeliveryPendingBanner extends StatelessWidget {
  final List<Reservation> activeReservations;

  const DeliveryPendingBanner({super.key, required this.activeReservations});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
  color: colorScheme.tertiary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber, color: colorScheme.tertiary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Reservas pendientes de entrega: ${activeReservations.length}',
              style: TextStyle(
                color: colorScheme.tertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
