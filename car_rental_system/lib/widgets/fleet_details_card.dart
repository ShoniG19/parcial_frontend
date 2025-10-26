import 'package:flutter/material.dart';

class FleetDetailsCard extends StatelessWidget {
  final int totalVehicles;
  final int totalAvailable;

  const FleetDetailsCard({
    super.key,
    required this.totalVehicles,
    required this.totalAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    final inUse = totalVehicles - totalAvailable;
    final availability = (totalAvailable / totalVehicles) * 100;
    final occupancy = (inUse / totalVehicles) * 100;

    return Card(
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detalles de Flota',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
            ),
            const SizedBox(height: 8),
            _buildRow('Vehículos en uso', '$inUse', colorScheme.primary),
            _buildRow('Disponibilidad', '${availability.toStringAsFixed(1)}%', colorScheme.secondary),
            _buildRow('Ocupación', '${occupancy.toStringAsFixed(1)}%', colorScheme.tertiary),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              )),
        ],
      ),
    );
  }
}
