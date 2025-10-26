import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/car_rental_provider.dart';
import '../../models/reservation.dart';
import '../../widgets/reservation_form.dart';
import 'reservation_list.dart';
import 'reservation_empty_state.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  bool _showActiveOnly = true;

  void _showReservationForm({Reservation? reservation}) {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return AlertDialog(
          title: Text(
            reservation == null ? 'Nueva Reserva' : 'Editar Reserva',
            style: TextStyle(color: colorScheme.primary),
          ),
          content: SingleChildScrollView(
            child: ReservationForm(
              reservation: reservation,
              onSave: (newReservation) {
                final provider = Provider.of<CarRentalProvider>(context, listen: false);
                if (reservation == null) {
                  provider.addReservation(newReservation);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reserva creada exitosamente')),
                  );
                } else {
                  provider.updateReservation(newReservation);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reserva actualizada exitosamente')),
                  );
                }
                Navigator.pop(context);
              },
            ),
          ),
        );
      }
    );
  } 

  void _deleteReservation(Reservation reservation) {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return AlertDialog(
          title: Text(
            'Confirmar eliminación',
            style: TextStyle(color: colorScheme.primary),
          ),
          content: Text('¿Está seguro que desea eliminar la reserva ${reservation.idReserva}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final provider = Provider.of<CarRentalProvider>(context, listen: false);
                provider.deleteReservation(reservation.idReserva);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Reserva eliminada exitosamente')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              child: Text('Eliminar'),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "Reservas",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ),
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          // Botón de filtro
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: PopupMenuButton<bool>(
              icon: Icon(Icons.filter_alt, color: colorScheme.primary),
              onSelected: (value) => setState(() => _showActiveOnly = value),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: true,
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      const Text('Solo activas'),
                      if (_showActiveOnly)
                        Icon(Icons.check, color: colorScheme.primary),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: false,
                  child: Row(
                    children: [
                      Icon(Icons.list, color: colorScheme.secondary),
                      const SizedBox(width: 8),
                      const Text('Todas'),
                      if (!_showActiveOnly)
                        Icon(Icons.check, color: colorScheme.primary),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Botón de agregar
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () => _showReservationForm(),
              icon: const Icon(Icons.add),
              label: const Text('Agregar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<CarRentalProvider>(
        builder: (context, provider, child) {
          final reservations = _showActiveOnly
              ? provider.getActiveReservations()
              : provider.reservations;

          if (reservations.isEmpty) {
            return ReservationEmptyState(
              showActiveOnly: _showActiveOnly,
              onAdd: _showReservationForm,
            );
          }

          return ReservationList(
            reservations: reservations,
            onEdit: _showReservationForm,
            onDelete: _deleteReservation,
          );
        },
      ),
    );
  }
}