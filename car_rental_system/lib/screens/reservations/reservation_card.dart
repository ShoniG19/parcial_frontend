import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/reservation.dart';
import '../../providers/navigation_provider.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final String clientName;
  final String vehicleName;
  final void Function({Reservation? reservation}) onEdit;
  final void Function(Reservation reservation) onDelete;

  const ReservationCard({
    super.key,
    required this.reservation,
    required this.clientName,
    required this.vehicleName,
    required this.onEdit,
    required this.onDelete,
  });

  Color _getStatusColor(ColorScheme colorScheme) {
    if (!reservation.activa) return colorScheme.outline;
    if (reservation.isVencida) return colorScheme.error;
    if (reservation.enCurso) return colorScheme.primary;
    return colorScheme.secondary;
  }

  String _getStatusText() {
    if (!reservation.activa) return 'Finalizada';
    if (reservation.isVencida) return 'Vencida';
    if (reservation.enCurso) return 'En curso';
    return 'Programada';
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = _getStatusColor(colorScheme);
    final statusText = _getStatusText();

    return Card(
      color: colorScheme.surface,
      child: ExpansionTile(
        leading: CircleAvatar(backgroundColor: statusColor, radius: 6),
        title: Text(
          'Reserva #${reservation.idReserva}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estado: $statusText', style: TextStyle(color: colorScheme.onSurfaceVariant)),
            Text('Cliente: $clientName', style: TextStyle(color: colorScheme.onSurfaceVariant)),
            Text('Vehículo: $vehicleName', style: TextStyle(color: colorScheme.onSurfaceVariant)),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(Icons.calendar_today, 'Inicio: ${_formatDate(reservation.fechaInicio)}', colorScheme),
                _infoRow(Icons.calendar_today, 'Fin: ${_formatDate(reservation.fechaFin)}', colorScheme),
                _infoRow(Icons.access_time, 'Duración: ${reservation.duracionDias} día(s)', colorScheme),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (reservation.activa)
                      ...[
                        TextButton(onPressed: () => onEdit(reservation: reservation), child: const Text('Editar')),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                            Provider.of<NavigationProvider>(context, listen: false).setSelectedIndex(4);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                          ),
                          child: const Text('Procesar Entrega'),
                        ),
                        const SizedBox(width: 8),
                      ],
                    TextButton(
                      onPressed: () => onDelete(reservation),
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

  Widget _infoRow(IconData icon, String text, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
