import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reservation.dart';
import '../models/client.dart';
import '../models/vehicle.dart';
import '../providers/car_rental_provider.dart';

class ReservationForm extends StatefulWidget {
  final Reservation? reservation;
  final Function(Reservation) onSave;

  const ReservationForm({
    Key? key,
    this.reservation,
    required this.onSave,
  }) : super(key: key);

  @override
  _ReservationFormState createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final _formKey = GlobalKey<FormState>();
  
  Client? _selectedClient;
  Vehicle? _selectedVehicle;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  @override
  void initState() {
    super.initState();
    if (widget.reservation != null) {
      _fechaInicio = widget.reservation!.fechaInicio;
      _fechaFin = widget.reservation!.fechaFin;
      // Necesitaremos encontrar el cliente y vehículo seleccionados
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = Provider.of<CarRentalProvider>(context, listen: false);
        setState(() {
          _selectedClient = provider.getClientById(widget.reservation!.idCliente);
          _selectedVehicle = provider.getVehicleById(widget.reservation!.idVehiculo);
        });
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate 
          ? (_fechaInicio ?? DateTime.now())
          : (_fechaFin ?? DateTime.now().add(Duration(days: 1))),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _fechaInicio = picked;
          // Si la fecha de fin es anterior a la nueva fecha de inicio, ajustarla
          if (_fechaFin != null && _fechaFin!.isBefore(picked)) {
            _fechaFin = picked.add(Duration(days: 1));
          }
        } else {
          _fechaFin = picked;
        }
      });
    }
  }

  void _saveReservation() {
    if (_formKey.currentState!.validate()) {
      if (_selectedClient == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Debe seleccionar un cliente'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedVehicle == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Debe seleccionar un vehículo'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_fechaInicio == null || _fechaFin == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Debe seleccionar las fechas'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final provider = Provider.of<CarRentalProvider>(context, listen: false);
      
      final reservation = Reservation(
        idReserva: widget.reservation?.idReserva ?? provider.generateReservationId(),
        idCliente: _selectedClient!.idCliente,
        idVehiculo: _selectedVehicle!.idVehiculo,
        fechaInicio: _fechaInicio!,
        fechaFin: _fechaFin!,
        activa: widget.reservation?.activa ?? true,
      );

      widget.onSave(reservation);
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
            // Selector de Cliente
            Consumer<CarRentalProvider>(
              builder: (context, provider, child) {
                final clients = provider.clients;
                return DropdownButtonFormField<Client>(
                  value: _selectedClient,
                  decoration: InputDecoration(
                    labelText: 'Cliente *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  items: clients.map((client) {
                    return DropdownMenuItem<Client>(
                      value: client,
                      child: Text(client.nombreCompleto),
                    );
                  }).toList(),
                  onChanged: (client) {
                    setState(() {
                      _selectedClient = client;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Debe seleccionar un cliente';
                    }
                    return null;
                  },
                );
              },
            ),
            SizedBox(height: 16),
            
            // Selector de Vehículo
            Consumer<CarRentalProvider>(
              builder: (context, provider, child) {
                // Para editar reservas, incluir el vehículo actual aunque no esté disponible
                final availableVehicles = widget.reservation != null 
                    ? provider.vehicles.where((v) => v.disponible || v.idVehiculo == widget.reservation!.idVehiculo).toList()
                    : provider.getAvailableVehicles();
                
                return DropdownButtonFormField<Vehicle>(
                  value: _selectedVehicle,
                  decoration: InputDecoration(
                    labelText: 'Vehículo *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.directions_car),
                    helperText: 'Solo se muestran vehículos disponibles',
                  ),
                  items: availableVehicles.map((vehicle) {
                    return DropdownMenuItem<Vehicle>(
                      value: vehicle,
                      child: Text('${vehicle.marca} ${vehicle.modelo} (${vehicle.ano})'),
                    );
                  }).toList(),
                  onChanged: availableVehicles.isNotEmpty ? (vehicle) {
                    setState(() {
                      _selectedVehicle = vehicle;
                    });
                  } : null,
                  validator: (value) {
                    if (value == null) {
                      return 'Debe seleccionar un vehículo';
                    }
                    return null;
                  },
                );
              },
            ),
            SizedBox(height: 16),
            
            // Fecha de Inicio
            InkWell(
              onTap: () => _selectDate(context, true),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Fecha de Inicio *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _fechaInicio == null 
                      ? 'Seleccionar fecha'
                      : '${_fechaInicio!.day.toString().padLeft(2, '0')}/${_fechaInicio!.month.toString().padLeft(2, '0')}/${_fechaInicio!.year}',
                ),
              ),
            ),
            SizedBox(height: 16),
            
            // Fecha de Fin
            InkWell(
              onTap: () => _selectDate(context, false),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Fecha de Fin *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _fechaFin == null 
                      ? 'Seleccionar fecha'
                      : '${_fechaFin!.day.toString().padLeft(2, '0')}/${_fechaFin!.month.toString().padLeft(2, '0')}/${_fechaFin!.year}',
                ),
              ),
            ),
            
            // Mostrar duración si ambas fechas están seleccionadas
            if (_fechaInicio != null && _fechaFin != null) ...[
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Duración: ${_fechaFin!.difference(_fechaInicio!).inDays + 1} día(s)',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
            
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
                  onPressed: _saveReservation,
                  child: Text(widget.reservation == null ? 'Crear Reserva' : 'Actualizar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}