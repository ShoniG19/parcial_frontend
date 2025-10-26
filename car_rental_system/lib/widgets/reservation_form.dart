import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reservation.dart';
import '../providers/car_rental_provider.dart';

class ReservationForm extends StatefulWidget {
  final Reservation? reservation;
  final Function(Reservation) onSave;

  const ReservationForm({super.key, this.reservation, required this.onSave});

  @override
  _ReservationFormState createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedClientId;
  String? _selectedVehicleId;
  DateTime? _inicio;
  DateTime? _fin;
  String? _fechaError;

  String? _validateDates() {
    if (_inicio == null || _fin == null) return null;
    
    if (_fin!.isBefore(_inicio!)) {
      return 'La fecha de fin debe ser posterior a la fecha de inicio';
    }
    
    if (_inicio!.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return 'La fecha de inicio no puede ser en el pasado';
    }
    
    final difference = _fin!.difference(_inicio!);
    if (difference.inDays < 1) {
      return 'La reserva debe ser de al menos 1 día';
    }
    
    if (difference.inDays > 365) {
      return 'La reserva no puede exceder 1 año';
    }
    
    return null;
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (_inicio ?? DateTime.now()) : (_fin ?? DateTime.now().add(const Duration(days: 1))),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        if (isStart) {
          _inicio = picked;
          if (_fin == null || _fin!.isBefore(_inicio!)) {
            _fin = _inicio!.add(const Duration(days: 1));
          }
        } else {
          _fin = picked;
        }
        _fechaError = _validateDates();
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedClientId == null || _selectedVehicleId == null || _inicio == null || _fin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete todos los campos obligatorios')),
      );
      return;
    }

    _fechaError = _validateDates();
    if (_fechaError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_fechaError!)),
      );
      return;
    }

    final provider = Provider.of<CarRentalProvider>(context, listen: false);
    final reservation = Reservation(
      idReserva: widget.reservation?.idReserva ?? provider.generateReservationId(),
      idCliente: _selectedClientId!,
      idVehiculo: _selectedVehicleId!,
      fechaInicio: _inicio!,
      fechaFin: _fin!,
      activa: widget.reservation?.activa ?? true,
    );
    widget.onSave(reservation);
  }

  @override
  void initState() {
    super.initState();
    if (widget.reservation != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedClientId = widget.reservation!.idCliente;
          _selectedVehicleId = widget.reservation!.idVehiculo;
          _inicio = widget.reservation!.fechaInicio;
          _fin = widget.reservation!.fechaFin;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Form(
        key: _formKey,
        child: Consumer<CarRentalProvider>(
          builder: (context, provider, _) {
            final clients = provider.clients;
            var vehicles = provider.getAvailableVehicles();
            
            if (widget.reservation != null && widget.reservation!.idVehiculo.isNotEmpty) {
              final currentVehicle = provider.getVehicleById(widget.reservation!.idVehiculo);
              if (currentVehicle != null && !vehicles.any((v) => v.idVehiculo == currentVehicle.idVehiculo)) {
                vehicles = [currentVehicle, ...vehicles];
              }
            }

            // Asegurar que los valores seleccionados existan en las listas actuales
            final clientIds = clients.map((c) => c.idCliente).toSet();
            final vehicleIds = vehicles.map((v) => v.idVehiculo).toSet();
            final validSelectedClientId = clientIds.contains(_selectedClientId) ? _selectedClientId : null;
            final validSelectedVehicleId = vehicleIds.contains(_selectedVehicleId) ? _selectedVehicleId : null;

            // Sincronizar estado si el valor actual dejó de ser válido
            if (_selectedClientId != null && validSelectedClientId == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() => _selectedClientId = null);
              });
            }
            if (_selectedVehicleId != null && validSelectedVehicleId == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() => _selectedVehicleId = null);
              });
            }

            if (_selectedVehicleId != null) {
              final selectedVehicleExists = vehicles.any((v) => v.idVehiculo == _selectedVehicleId);
              if (!selectedVehicleExists) {
                // Resetear la selección si el vehículo ya no está disponible
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _selectedVehicleId = null;
                    });
                  }
                });
              }
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Cliente *',
                    prefixIcon: Icon(Icons.person, color: colorScheme.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  value: validSelectedClientId,
                  items: () {
                    // Filtrar clientes para evitar IDs duplicados
                    final Set<String> seenIds = <String>{};
                    final List<DropdownMenuItem<String>> uniqueItems = [];
                    
                    for (final client in clients) {
                      if (!seenIds.contains(client.idCliente)) {
                        seenIds.add(client.idCliente);
                        uniqueItems.add(DropdownMenuItem<String>(
                          value: client.idCliente,
                          child: Text(
                            client.nombreCompleto,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ));
                      }
                    }
                    return uniqueItems;
                  }(),
                  onChanged: (clientId) => setState(() => _selectedClientId = clientId),
                  validator: (v) => v == null ? 'Seleccione un cliente' : null,
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Vehículo *',
                    prefixIcon: Icon(Icons.directions_car, color: colorScheme.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  value: validSelectedVehicleId,
                  items: () {
                    // Filtrar vehículos para evitar IDs duplicados
                    final Set<String> seenIds = <String>{};
                    final List<DropdownMenuItem<String>> uniqueItems = [];
                    
                    for (final vehicle in vehicles) {
                      if (!seenIds.contains(vehicle.idVehiculo)) {
                        seenIds.add(vehicle.idVehiculo);
                        final vehicleName = '${vehicle.marca} ${vehicle.modelo} (${vehicle.anho})' +
                            (vehicle.disponible ? '' : ' (no disponible)');
                        uniqueItems.add(DropdownMenuItem<String>(
                          value: vehicle.idVehiculo,
                          child: Text(
                            vehicleName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ));
                      }
                    }
                    return uniqueItems;
                  }(),
                  onChanged: (vehicleId) => setState(() => _selectedVehicleId = vehicleId),
                  validator: (v) => v == null ? 'Seleccione un vehículo' : null,
                ),
                const SizedBox(height: 16),

                _buildDateField('Inicio *', _inicio, () => _pickDate(true)),
                const SizedBox(height: 16),
                _buildDateField('Fin *', _fin, () => _pickDate(false)),
                
                if (_fechaError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: colorScheme.error, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _fechaError!,
                            style: TextStyle(
                              color: colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                const SizedBox(height: 24),
                _buildActions(context, colorScheme),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? date, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.calendar_today, color: colorScheme.primary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          date == null
              ? 'Seleccionar fecha'
              : '${date.day}/${date.month}/${date.year}',
          style: TextStyle(
            color: date == null 
                ? Theme.of(context).hintColor 
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
      child: Text('Cancelar',
        style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7))),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
          child: Text(widget.reservation == null ? 'Crear' : 'Actualizar'),
        ),
      ],
    );
  }
}