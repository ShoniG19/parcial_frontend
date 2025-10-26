import 'package:flutter/material.dart';
import '../models/vehicle.dart';

class VehicleForm extends StatefulWidget {
  final Vehicle? vehicle;
  final Function(Vehicle) onSave;

  const VehicleForm({
    super.key,
    this.vehicle,
    required this.onSave,
  });

  @override
  State<VehicleForm> createState() => _VehicleFormState();
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
    _anoController = TextEditingController(text: widget.vehicle?.anho.toString() ?? '');
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
        anho: int.parse(_anoController.text),
        disponible: _disponible,
      );

      widget.onSave(vehicle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              controller: _marcaController,
              label: 'Marca *',
              hint: 'Ej: Toyota, Ford, Honda',
              icon: Icons.branding_watermark,
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'La marca es obligatoria'
                  : v.trim().length < 2
                      ? 'Debe tener al menos 2 caracteres'
                      : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _modeloController,
              label: 'Modelo *',
              hint: 'Ej: Corolla, Focus, Civic',
              icon: Icons.model_training,
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'El modelo es obligatorio'
                  : v.trim().length < 2
                      ? 'Debe tener al menos 2 caracteres'
                      : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _anoController,
              label: 'Año *',
              hint: 'Ej: ${DateTime.now().year}',
              icon: Icons.calendar_today,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'El año es obligatorio';
                final year = int.tryParse(v);
                if (year == null) return 'Debe ser un número válido';
                final current = DateTime.now().year;
                if (year < 1900 || year > current + 1) {
                  return 'Debe estar entre 1900 y ${current + 1}';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _disponible ? Icons.check_circle : Icons.cancel,
                    color: _disponible
                        ? colorScheme.primary
                        : colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Disponibilidad',
                      style: TextStyle(color: colorScheme.onSurface)),
                  ),
                  Switch(
                    value: _disponible,
                    onChanged: (v) => setState(() => _disponible = v),
                    activeThumbColor: colorScheme.primary,
                    activeTrackColor: colorScheme.primary.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                      foregroundColor: colorScheme.onSurface.withValues(alpha: 0.7)),
                  child: Text('Cancelar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveVehicle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: Text(widget.vehicle == null ? 'Agregar' : 'Actualizar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: colorScheme.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }
}