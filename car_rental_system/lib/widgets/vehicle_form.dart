import 'package:flutter/material.dart';
import '../models/vehicle.dart';

class VehicleForm extends StatefulWidget {
  final Vehicle? vehicle;
  final Function(Vehicle) onSave;

  const VehicleForm({
    Key? key,
    this.vehicle,
    required this.onSave,
  }) : super(key: key);

  @override
  _VehicleFormState createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _anoController;
  bool _disponible = true;

  @override
  void initState() {
    super.initState();
    _marcaController = TextEditingController(text: widget.vehicle?.marca ?? '');
    _modeloController = TextEditingController(text: widget.vehicle?.modelo ?? '');
    _anoController = TextEditingController(text: widget.vehicle?.ano.toString() ?? '');
    _disponible = widget.vehicle?.disponible ?? true;
  }

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _anoController.dispose();
    super.dispose();
  }

  void _saveVehicle() {
    if (_formKey.currentState!.validate()) {
      final vehicle = Vehicle(
        idVehiculo: widget.vehicle?.idVehiculo ?? 
                   DateTime.now().millisecondsSinceEpoch.toString(),
        marca: _marcaController.text.trim(),
        modelo: _modeloController.text.trim(),
        ano: int.parse(_anoController.text),
        disponible: _disponible,
      );

      widget.onSave(vehicle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Campo Marca
            TextFormField(
              controller: _marcaController,
              decoration: InputDecoration(
                labelText: 'Marca *',
                hintText: 'Ej: Toyota, Ford, Honda',
                prefixIcon: Icon(Icons.branding_watermark),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La marca es obligatoria';
                }
                if (value.trim().length < 2) {
                  return 'La marca debe tener al menos 2 caracteres';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Campo Modelo
            TextFormField(
              controller: _modeloController,
              decoration: InputDecoration(
                labelText: 'Modelo *',
                hintText: 'Ej: Corolla, Focus, Civic',
                prefixIcon: Icon(Icons.model_training),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El modelo es obligatorio';
                }
                if (value.trim().length < 2) {
                  return 'El modelo debe tener al menos 2 caracteres';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Campo Año
            TextFormField(
              controller: _anoController,
              decoration: InputDecoration(
                labelText: 'Año *',
                hintText: 'Ej: ${DateTime.now().year}',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El año es obligatorio';
                }
                
                final ano = int.tryParse(value);
                if (ano == null) {
                  return 'El año debe ser un número válido';
                }

                final currentYear = DateTime.now().year;
                if (ano < 1900 || ano > currentYear + 1) {
                  return 'El año debe estar entre 1900 y ${currentYear + 1}';
                }

                return null;
              },
            ),
            SizedBox(height: 16),

            // Switch Disponibilidad
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(
                    _disponible ? Icons.check_circle : Icons.cancel,
                    color: _disponible ? Colors.green : Colors.red,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Disponibilidad',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Switch(
                    value: _disponible,
                    onChanged: (value) {
                      setState(() {
                        _disponible = value;
                      });
                    },
                    activeColor: Colors.green,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: _saveVehicle,
                  child: Text(widget.vehicle == null ? 'Agregar' : 'Actualizar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}