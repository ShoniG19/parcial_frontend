import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/car_rental_provider.dart';
import '../models/reservation.dart';
import '../widgets/reservation_form.dart';

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  bool _showActiveOnly = true;

  void _showReservationForm({Reservation? reservation}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(reservation == null ? 'Nueva Reserva' : 'Editar Reserva'),
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
      ),
    );
  }

  void _deleteReservation(Reservation reservation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Está seguro que desea eliminar la reserva ${reservation.idReserva}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Color _getReservationStatusColor(Reservation reservation) {
    if (!reservation.activa) return Colors.grey;
    if (reservation.isVencida) return Colors.red;
    if (reservation.enCurso) return Colors.green;
    return Colors.blue;
  }

  String _getReservationStatusText(Reservation reservation) {
    if (!reservation.activa) return 'Finalizada';
    if (reservation.isVencida) return 'Vencida';
    if (reservation.enCurso) return 'En curso';
    return 'Programada';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Reservas'),
        actions: [
          PopupMenuButton<bool>(
            onSelected: (value) {
              setState(() {
                _showActiveOnly = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: true,
                child: Row(
                  children: [
                    Icon(Icons.filter_alt, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Solo activas'),
                    if (_showActiveOnly) Icon(Icons.check, color: Colors.green),
                  ],
                ),
              ),
              PopupMenuItem(
                value: false,
                child: Row(
                  children: [
                    Icon(Icons.list, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Todas'),
                    if (!_showActiveOnly) Icon(Icons.check, color: Colors.green),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showReservationForm(),
          ),
        ],
      ),
      body: Consumer<CarRentalProvider>(
        builder: (context, provider, child) {
          final reservations = _showActiveOnly 
              ? provider.getActiveReservations() 
              : provider.reservations;

          if (reservations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    _showActiveOnly 
                        ? 'No hay reservas activas'
                        : 'No hay reservas registradas',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showReservationForm(),
                    child: Text('Crear Primera Reserva'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              final client = provider.getClientById(reservation.idCliente);
              final vehicle = provider.getVehicleById(reservation.idVehiculo);
              final statusColor = _getReservationStatusColor(reservation);
              final statusText = _getReservationStatusText(reservation);

              return Card(
                child: ExpansionTile(
                  leading: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(
                    'Reserva #${reservation.idReserva}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Estado: $statusText'),
                      Text('Cliente: ${client?.nombreCompleto ?? 'Desconocido'}'),
                      Text('Vehículo: ${vehicle?.toString() ?? 'Desconocido'}'),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16),
                              SizedBox(width: 8),
                              Text('Fecha de inicio: ${_formatDate(reservation.fechaInicio)}'),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16),
                              SizedBox(width: 8),
                              Text('Fecha de fin: ${_formatDate(reservation.fechaFin)}'),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 16),
                              SizedBox(width: 8),
                              Text('Duración: ${reservation.duracionDias} día(s)'),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (reservation.activa) ...[
                                TextButton(
                                  onPressed: () => _showReservationForm(reservation: reservation),
                                  child: Text('Editar'),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/deliveries');
                                  },
                                  child: Text('Procesar Entrega'),
                                ),
                                SizedBox(width: 8),
                              ],
                              TextButton(
                                onPressed: () => _deleteReservation(reservation),
                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                                child: Text('Eliminar'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showReservationForm(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}