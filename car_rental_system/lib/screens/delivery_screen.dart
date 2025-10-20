import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/car_rental_provider.dart';
import '../models/delivery.dart';
import '../widgets/delivery_form.dart';

class DeliveryScreen extends StatelessWidget {
  void _showDeliveryForm(BuildContext context, {Delivery? delivery}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(delivery == null ? 'Registrar Entrega' : 'Editar Entrega'),
        content: SingleChildScrollView(
          child: DeliveryForm(
            delivery: delivery,
            onSave: (newDelivery) {
              final provider = Provider.of<CarRentalProvider>(context, listen: false);
              if (delivery == null) {
                provider.addDelivery(newDelivery);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Entrega registrada exitosamente')),
                );
              } else {
                provider.updateDelivery(newDelivery);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Entrega actualizada exitosamente')),
                );
              }
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  void _deleteDelivery(BuildContext context, Delivery delivery) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Está seguro que desea eliminar la entrega ${delivery.idEntrega}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final provider = Provider.of<CarRentalProvider>(context, listen: false);
              provider.deleteDelivery(delivery.idEntrega);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Entrega eliminada exitosamente')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Entregas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showDeliveryForm(context),
          ),
        ],
      ),
      body: Consumer<CarRentalProvider>(
        builder: (context, provider, child) {
          final deliveries = provider.deliveries;
          final activeReservations = provider.getActiveReservations();

          return Column(
            children: [
              // Sección de reservas pendientes de entrega
              if (activeReservations.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  color: Colors.orange.withOpacity(0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning_amber, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            'Reservas Pendientes de Entrega (${activeReservations.length})',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade800,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Hay ${activeReservations.length} reserva(s) activa(s) que requieren procesamiento de entrega.',
                        style: TextStyle(color: Colors.orange.shade700),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
              ],

              // Lista de entregas registradas
              Expanded(
                child: deliveries.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.assignment_return, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No hay entregas registradas',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => _showDeliveryForm(context),
                              child: Text('Registrar Primera Entrega'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: deliveries.length,
                        itemBuilder: (context, index) {
                          final delivery = deliveries[index];
                          final reservation = provider.getReservationById(delivery.idReserva);
                          final client = reservation != null 
                              ? provider.getClientById(reservation.idCliente) 
                              : null;
                          final vehicle = reservation != null 
                              ? provider.getVehicleById(reservation.idVehiculo) 
                              : null;

                          return Card(
                            child: ExpansionTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.green,
                                child: Icon(Icons.assignment_turned_in, color: Colors.white),
                              ),
                              title: Text(
                                'Entrega #${delivery.idEntrega}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Reserva: #${delivery.idReserva}'),
                                  Text('Cliente: ${client?.nombreCompleto ?? 'Desconocido'}'),
                                  Text('Fecha: ${_formatDate(delivery.fechaEntregaReal)}'),
                                ],
                              ),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (vehicle != null) ...[
                                        Row(
                                          children: [
                                            Icon(Icons.directions_car, size: 16),
                                            SizedBox(width: 8),
                                            Text('Vehículo: ${vehicle.toString()}'),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                      ],
                                      if (delivery.kilometrajeFinal != null) ...[
                                        Row(
                                          children: [
                                            Icon(Icons.speed, size: 16),
                                            SizedBox(width: 8),
                                            Text('Kilometraje final: ${delivery.kilometrajeFinal} km'),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                      ],
                                      if (delivery.observaciones != null && delivery.observaciones!.isNotEmpty) ...[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.note, size: 16),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Text('Observaciones: ${delivery.observaciones}'),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                      ],
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () => _showDeliveryForm(context, delivery: delivery),
                                            child: Text('Editar'),
                                          ),
                                          SizedBox(width: 8),
                                          TextButton(
                                            onPressed: () => _deleteDelivery(context, delivery),
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
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDeliveryForm(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}