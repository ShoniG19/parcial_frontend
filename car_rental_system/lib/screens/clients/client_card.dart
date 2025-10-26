import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/client.dart';
import '../../providers/car_rental_provider.dart';

class ClientCard extends StatelessWidget {
  final Client client;
  final Function(Client client) onEdit;
  final Function(Client client) onDelete;

  const ClientCard({
    super.key,
    required this.client,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.secondary,
          child: Text(
            client.nombre[0].toUpperCase(),
            style: TextStyle(color: colorScheme.onSecondary),
          ),
        ),
        title: Text(
          client.nombreCompleto,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Consumer<CarRentalProvider>(
          builder: (context, provider, _) {
            final count = provider.getReservationCountForClient(client.idCliente);
            return Text(
              'Documento: ${client.documento}\nReservas: $count',
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
            );
          },
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
          onSelected: (value) {
            if (value == 'edit') onEdit(client);
            if (value == 'delete') onDelete(client);
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
