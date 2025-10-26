import 'package:flutter/material.dart';
import '../../models/delivery.dart';
import '../../providers/car_rental_provider.dart';
import 'delivery_card.dart';
import 'package:provider/provider.dart';

class DeliveryList extends StatelessWidget {
  final List<Delivery> deliveries;
  final Function({Delivery? delivery}) onEdit;
  final Function(Delivery delivery) onDelete;
  final VoidCallback onAddFirst;

  const DeliveryList({
    super.key,
    required this.deliveries,
    required this.onEdit,
    required this.onDelete,
    required this.onAddFirst,
  });

  @override
  Widget build(BuildContext context) { 
    final colorScheme = Theme.of(context).colorScheme;
    final provider = context.read<CarRentalProvider>();

    if (deliveries.isEmpty) {
      return SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_return,
                  size: 64,
                  color: colorScheme.primary.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 16),
                Text(
                  'No hay entregas registradas',
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: onAddFirst,
                  icon: const Icon(Icons.add),
                  label: const Text('Registrar primera entrega'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: deliveries.length,
      itemBuilder: (context, index) {
        final delivery = deliveries[index];
        final reservation = provider.getReservationById(delivery.idReserva);
        final client = reservation != null ? provider.getClientById(reservation.idCliente) : null;
        final vehicle = reservation != null ? provider.getVehicleById(reservation.idVehiculo) : null;

        return DeliveryCard(
          delivery: delivery,
          clientName: client?.nombreCompleto ?? 'Desconocido',
          vehicleInfo: vehicle?.toString() ?? 'N/A',
          onEdit: () => onEdit(delivery: delivery),
          onDelete: () => onDelete(delivery),
        );
      },
    );
  }
}
