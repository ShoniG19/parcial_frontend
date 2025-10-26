import 'package:flutter/material.dart';
import '../../models/vehicle.dart';
import 'vehicle_card.dart';

class VehicleList extends StatelessWidget {
  final List<Vehicle> vehicles;
  final Function(Vehicle vehicle) onEdit;
  final Function(Vehicle vehicle) onDelete;
  final VoidCallback onAddFirst;

  const VehicleList({
    super.key,
    required this.vehicles,
    required this.onEdit,
    required this.onDelete,
    required this.onAddFirst,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (vehicles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car_outlined, size: 64, color: colorScheme.primary),
            const SizedBox(height: 16),
            Text('No hay vehículos registrados', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7))),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onAddFirst,
              icon: const Icon(Icons.add),
              label: const Text('Agregar primer cliente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        return VehicleCard(
          vehicle: vehicles[index],
          onEdit: onEdit,
          onDelete: onDelete,
        );
      },
    );
  }
}
