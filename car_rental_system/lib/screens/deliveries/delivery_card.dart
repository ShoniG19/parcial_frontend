import 'package:flutter/material.dart';
import '../../models/delivery.dart';

class DeliveryCard extends StatelessWidget {
  final Delivery delivery;
  final String clientName;
  final String vehicleInfo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DeliveryCard({
    super.key,
    required this.delivery,
    required this.clientName,
    required this.vehicleInfo,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.secondary,
          child: Icon(Icons.assignment_turned_in, color: colorScheme.onSecondary),
        ),
        title: Text(
          'Entrega #${delivery.idEntrega}',
          style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reserva: #${delivery.idReserva}', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.8))),
            Text('Cliente: $clientName', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.8))),
            Text('Fecha: ${_formatDate(delivery.fechaEntregaReal)}', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.8))),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Vehículo: $vehicleInfo'),
                if (delivery.kilometrajeFinal != null)
                  Text('Kilometraje final: ${delivery.kilometrajeFinal} km'),
                if (delivery.observaciones?.isNotEmpty ?? false)
                  Text('Observaciones: ${delivery.observaciones}'),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: onEdit,
                      child: Text('Editar', style: TextStyle(color: colorScheme.primary)),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: onDelete,
                      style: TextButton.styleFrom(foregroundColor: colorScheme.error),
                      child: const Text('Eliminar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
