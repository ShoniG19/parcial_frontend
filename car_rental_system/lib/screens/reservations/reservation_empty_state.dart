import 'package:flutter/material.dart';

class ReservationEmptyState extends StatelessWidget {
  final bool showActiveOnly;
  final VoidCallback onAdd;

  const ReservationEmptyState({
    super.key,
    required this.showActiveOnly,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book_outlined, size: 72, color: colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            showActiveOnly
                ? 'No hay reservas activas'
                : 'No hay reservas registradas',
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 16),
          ),
          const SizedBox(height: 16),
           ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Crear Primera Reserva'),
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
}
