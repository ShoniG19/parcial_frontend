import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/delivery.dart';
import '../models/reservation.dart';
import '../providers/car_rental_provider.dart';

class DeliveryForm extends StatefulWidget {
  final Delivery? delivery;
  final Function(Delivery) onSave;

  const DeliveryForm({
    super.key,
    this.delivery,
    required this.onSave,
  });

  @override
  _DeliveryFormState createState() => _DeliveryFormState();
}

class _DeliveryFormState extends State<DeliveryForm> {
  final _formKey = GlobalKey<FormState>();

  Reservation? _selectedReservation;
  DateTime? _fechaEntrega;
  final _observacionesController = TextEditingController();
  final _kilometrajeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.delivery != null) {
      _fechaEntrega = widget.delivery!.fechaEntregaReal;
      _observacionesController.text = widget.delivery!.observaciones ?? '';
      _kilometrajeController.text =
          widget.delivery!.kilometrajeFinal?.toString() ?? '';

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = Provider.of<CarRentalProvider>(context, listen: false);
        setState(() {
          _selectedReservation =
              provider.getReservationById(widget.delivery!.idReserva);
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
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaEntrega ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final time = await showTimePicker(
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
    if (!_formKey.currentState!.validate()) return;

    if (_selectedReservation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar una reserva')),
      );
      return;
    }

    if (_fechaEntrega == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar la fecha de entrega')),
      );
      return;
    }

    final provider = Provider.of<CarRentalProvider>(context, listen: false);

    final delivery = Delivery(
      idEntrega:
          widget.delivery?.idEntrega ?? provider.generateDeliveryId(),
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Selector de Reserva
              Consumer<CarRentalProvider>(
                builder: (context, provider, _) {
                  final reservations = widget.delivery != null
                      ? provider.reservations
                          .where((r) =>
                              r.activa ||
                              r.idReserva == widget.delivery!.idReserva)
                          .toList()
                      : provider.getActiveReservations();

                  final validSelectedReservationId =
                      _selectedReservation != null &&
                              reservations.any((r) =>
                                  r.idReserva ==
                                  _selectedReservation!.idReserva)
                          ? _selectedReservation!.idReserva
                          : null;

                  return DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: validSelectedReservationId,
                    decoration: InputDecoration(
                      labelText: 'Reserva *',
                      prefixIcon:
                          Icon(Icons.book, color: colorScheme.primary),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      helperText: widget.delivery == null
                          ? 'Solo se muestran reservas activas'
                          : null,
                    ),
                    items: reservations.map((r) {
                      final client = provider.getClientById(r.idCliente);
                      final vehicle = provider.getVehicleById(r.idVehiculo);
                      final displayText = 
                          'Reserva #${r.idReserva} - ${client?.nombreCompleto ?? 'Cliente desconocido'} - ${vehicle?.marca ?? ''} ${vehicle?.modelo ?? ''}';
                      return DropdownMenuItem<String>(
                        value: r.idReserva,
                        child: Tooltip(
                          message: displayText,
                          child: Text(
                            displayText,
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedReservation = reservations.firstWhere(
                              (r) => r.idReserva == value);
                        });
                      }
                    },
                    validator: (value) =>
                        value == null ? 'Debe seleccionar una reserva' : null,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Fecha y Hora
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Fecha y Hora de Entrega *',
                    prefixIcon: Icon(Icons.access_time,
                        color: colorScheme.primary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    _fechaEntrega == null
                        ? 'Seleccionar fecha y hora'
                        : '${_fechaEntrega!.day.toString().padLeft(2, '0')}/${_fechaEntrega!.month.toString().padLeft(2, '0')}/${_fechaEntrega!.year} ${_fechaEntrega!.hour.toString().padLeft(2, '0')}:${_fechaEntrega!.minute.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Kilometraje Final
              TextFormField(
                controller: _kilometrajeController,
                decoration: InputDecoration(
                  labelText: 'Kilometraje Final (km)',
                  prefixIcon:
                      Icon(Icons.speed, color: colorScheme.primary),
                  helperText: 'Campo opcional',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
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
              const SizedBox(height: 16),

              // Observaciones
              TextFormField(
                controller: _observacionesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Observaciones',
                  prefixIcon:
                      Icon(Icons.note, color: colorScheme.primary),
                  helperText: 'Campo opcional para notas adicionales',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),

              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                          color:
                              colorScheme.onSurface.withOpacity(0.7)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _saveDelivery,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                        widget.delivery == null ? 'Registrar' : 'Actualizar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
