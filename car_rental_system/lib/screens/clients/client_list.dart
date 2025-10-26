import 'package:flutter/material.dart';
import '../../models/client.dart';
import 'client_card.dart';

class ClientList extends StatelessWidget {
  final List<Client> clients;
  final Function(Client client) onEdit;
  final Function(Client client) onDelete;
  final VoidCallback onAddFirst;

  const ClientList({
    super.key,
    required this.clients,
    required this.onEdit,
    required this.onDelete,
    required this.onAddFirst,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (clients.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'No hay clientes registrados',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
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
      itemCount: clients.length,
      itemBuilder: (context, index) {
        return ClientCard(
          client: clients[index],
          onEdit: onEdit,
          onDelete: onDelete,
        );
      },
    );
  }
}
