import 'package:flutter/material.dart';
import '../../models/vehicle.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final Function(Vehicle vehicle) onEdit;
  final Function(Vehicle vehicle) onDelete;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = vehicle.disponible ? colorScheme.secondary : colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
  border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: ListTile(
        leading: Icon(Icons.directions_car, color: color, size: 32),
        title: Text('${vehicle.marca} ${vehicle.modelo}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              ),
            ),
        subtitle: Text(
          'Año: ${vehicle.anho}\nDisponible: ${vehicle.disponibilidadTexto}',
          style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') onEdit(vehicle);
            if (value == 'delete') onDelete(vehicle);
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  const Text('Editar'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: colorScheme.error),
                  const SizedBox(width: 8),
                  const Text('Eliminar'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
