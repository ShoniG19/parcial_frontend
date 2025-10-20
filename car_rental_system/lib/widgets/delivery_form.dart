import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/delivery.dart';
import '../models/reservation.dart';
import '../providers/car_rental_provider.dart';

class DeliveryForm extends StatefulWidget {
  final Delivery? delivery;
  final Function(Delivery) onSave;

  const DeliveryForm({
    Key? key,
    this.delivery,
    required this.onSave,
  }) : super(key: key);

  @override
  _DeliveryFormState createState() => _DeliveryFormState();
}

class _DeliveryFormState extends State<DeliveryForm> {
  final _formKey = GlobalKey<FormState>();
  
  Reservation? _selectedReservation;
  DateTime? _fechaEntrega;
  final TextEditingController _observacionesController = TextEditingController();
  final TextEditingController _kilometrajeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.delivery != null) {
      _fechaEntrega = widget.delivery!.fechaEntregaReal;
      _observacionesController.text = widget.delivery!.observaciones ?? '';
      _kilometrajeController.text = widget.delivery!.kilometrajeFinal?.toString() ?? '';
      
      // Encontrar la reserva asociada
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = Provider.of<CarRentalProvider>(context, listen: false);
        setState(() {
          _selectedReservation = provider.getReservationById(widget.delivery!.idReserva);
        });
      });
    }
  }

  @override
  void dispose() {
    _observacionesController.dispose();
    _kilometrajeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaEntrega ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      
      if (time != null) {
        setState(() {
          _fechaEntrega = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _saveDelivery() {
    if (_formKey.currentState!.validate()) {
      if (_selectedReservation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Debe seleccionar una reserva'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_fechaEntrega == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Debe seleccionar la fecha de entrega'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final provider = Provider.of<CarRentalProvider>(context, listen: false);
      
      final delivery = Delivery(
        idEntrega: widget.delivery?.idEntrega ?? provider.generateDeliveryId(),
        idReserva: _selectedReservation!.idReserva,
        fechaEntregaReal: _fechaEntrega!,
        observaciones: _observacionesController.text.trim().isEmpty 
            ? null 
            : _observacionesController.text.trim(),
        kilometrajeFinal: _kilometrajeController.text.trim().isEmpty 
            ? null 
            : int.tryParse(_kilometrajeController.text.trim()),
      );

      widget.onSave(delivery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selector de Reserva (solo reservas activas para nuevas entregas)
            Consumer<CarRentalProvider>(
              builder: (context, provider, child) {
                final reservations = widget.delivery != null
                    ? provider.reservations.where((r) => 
                        r.activa || r.idReserva == widget.delivery!.idReserva).toList()
                    : provider.getActiveReservations();
                
                return DropdownButtonFormField<Reservation>(
                  value: _selectedReservation,
                  decoration: InputDecoration(
                    labelText: 'Reserva *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.book),
                    helperText: widget.delivery == null 
                        ? 'Solo se muestran reservas activas' 
                        : null,
                  ),
                  items: reservations.map((reservation) {
                    final client = provider.getClientById(reservation.idCliente);
                    final vehicle = provider.getVehicleById(reservation.idVehiculo);
                    
                    return DropdownMenuItem<Reservation>(
                      value: reservation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reserva #${reservation.idReserva}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${client?.nombreCompleto ?? 'Cliente desconocido'}',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            '${vehicle?.marca ?? ''} ${vehicle?.modelo ?? ''} (${vehicle?.ano ?? ''})',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: reservations.isNotEmpty ? (reservation) {
                    setState(() {
                      _selectedReservation = reservation;
                    });
                  } : null,
                  validator: (value) {
                    if (value == null) {
                      return 'Debe seleccionar una reserva';
                    }
                    return null;
                  },
                );
              },
            ),
            SizedBox(height: 16),
            
            // Fecha y Hora de Entrega
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Fecha y Hora de Entrega *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
                child: Text(
                  _fechaEntrega == null 
                      ? 'Seleccionar fecha y hora'
                      : '${_fechaEntrega!.day.toString().padLeft(2, '0')}/${_fechaEntrega!.month.toString().padLeft(2, '0')}/${_fechaEntrega!.year} ${_fechaEntrega!.hour.toString().padLeft(2, '0')}:${_fechaEntrega!.minute.toString().padLeft(2, '0')}',
                ),
              ),
            ),
            SizedBox(height: 16),
            
            // Kilometraje Final (opcional)
            TextFormField(
              controller: _kilometrajeController,
              decoration: InputDecoration(
                labelText: 'Kilometraje Final (km)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.speed),
                helperText: 'Campo opcional',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  final km = int.tryParse(value.trim());
                  if (km == null || km < 0) {
                    return 'Debe ser un número válido mayor a 0';
                  }
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            
            // Observaciones (opcional)
            TextFormField(
              controller: _observacionesController,
              decoration: InputDecoration(
                labelText: 'Observaciones',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
                helperText: 'Campo opcional para notas adicionales',
              ),
              maxLines: 3,
              validator: (value) {
                if (value != null && value.trim().length > 500) {
                  return 'Las observaciones no pueden exceder 500 caracteres';
                }
                return null;
              },
            ),
            
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveDelivery,
                  child: Text(widget.delivery == null ? 'Registrar Entrega' : 'Actualizar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}