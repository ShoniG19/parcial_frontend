import 'package:flutter/material.dart';
import '../../../models/client.dart';

class TopClientCard extends StatelessWidget {
  final Client? client;
  final int reservationCount;

  const TopClientCard({
    super.key,
    required this.client,
    required this.reservationCount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: colorScheme.tertiary),
                SizedBox(width: 8),
                Text('Cliente con Más Reservas',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorScheme.onSurface,
                    ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (client != null) ...[
              Text(
                client!.nombreCompleto,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.tertiary,
                ),
              ),
              Text('Documento: ${client!.documento}',
                  style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
              ),
              Text('Total de reservas: $reservationCount',
                  style: TextStyle(
                    color: colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                    ),
              ),
            ] else
              Text('No hay datos disponibles',
                  style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.5), fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
