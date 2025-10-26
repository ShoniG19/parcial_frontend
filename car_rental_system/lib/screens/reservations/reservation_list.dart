import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/car_rental_provider.dart';
import '../../models/reservation.dart';
import 'reservation_card.dart';

class ReservationList extends StatelessWidget {
  final List<Reservation> reservations;
  final void Function({Reservation? reservation}) onEdit;
  final void Function(Reservation reservation) onDelete;

  const ReservationList({
    super.key,
    required this.reservations,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CarRentalProvider>();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final reservation = reservations[index];
        final client = provider.getClientById(reservation.idCliente);
        final vehicle = provider.getVehicleById(reservation.idVehiculo);

        return ReservationCard(
          reservation: reservation,
          clientName: client?.nombreCompleto ?? 'Desconocido',
          vehicleName: vehicle?.toString() ?? 'Desconocido',
          onEdit: onEdit,
          onDelete: onDelete,
        );
      },
    );
  }
}
