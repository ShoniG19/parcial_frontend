import 'package:flutter/material.dart';
import 'stat_card.dart';

class StatsHeader extends StatelessWidget {
  final int totalActiveReservations;
  final int totalAvailableVehicles;

  const StatsHeader({
    super.key,
    required this.totalActiveReservations,
    required this.totalAvailableVehicles,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumen General',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Reservas Activas',
                value: totalActiveReservations.toString(),
                icon: Icons.book,
                color: colorScheme.tertiary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Vehículos Disponibles',
                value: totalAvailableVehicles.toString(),
                icon: Icons.directions_car,
                color: colorScheme.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
