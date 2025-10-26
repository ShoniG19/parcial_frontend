import 'package:flutter/material.dart';
import 'stat_card.dart';

class StatsGrid extends StatelessWidget {
  final int totalVehicles;
  final int totalClients;
  final int totalReservations;
  final int totalDeliveries;

  const StatsGrid({
    super.key,
    required this.totalVehicles,
    required this.totalClients,
    required this.totalReservations,
    required this.totalDeliveries,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        StatCard(
            title: 'Total Vehículos',
            value: '$totalVehicles',
            icon: Icons.directions_car,
            color: colorScheme.primary,
        ),
        StatCard(
            title: 'Total Clientes',
            value: '$totalClients',
            icon: Icons.people,
            color: colorScheme.secondary,
        ),
        StatCard(
            title: 'Total Reservas',
            value: '$totalReservations',
            icon: Icons.book_outlined,
            color: colorScheme.tertiary,
        ),
        StatCard(
            title: 'Total Entregas',
            value: '$totalDeliveries',
            icon: Icons.assignment_turned_in,
            color: colorScheme.primary.withValues(alpha: 0.8),
        ),
      ],
    );
  }
}
