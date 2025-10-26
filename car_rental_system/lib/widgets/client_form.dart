import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/client.dart';
import '../providers/car_rental_provider.dart';

class ClientForm extends StatefulWidget {
  final Client? client;
  final Function(Client) onSave;

  const ClientForm({
    super.key,
    this.client,
    required this.onSave,
  });

  @override
  _ClientFormState createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _documentoController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.client?.nombre ?? '');
    _apellidoController = TextEditingController(text: widget.client?.apellido ?? '');
    _documentoController = TextEditingController(text: widget.client?.documento ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _documentoController.dispose();
    super.dispose();
  }

  void _saveClient() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<CarRentalProvider>(context, listen: false);
      final colorScheme = Theme.of(context).colorScheme;
      
      // Verificar si el documento ya existe (solo para clientes nuevos o si cambió el documento)
      final existingClient = provider.clients.where((c) => 
          c.documento == _documentoController.text && 
          c.idCliente != (widget.client?.idCliente ?? '')).firstOrNull;
      
      if (existingClient != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ya existe un cliente con este documento'),
            backgroundColor: colorScheme.error,
          ),
        );
        return;
      }

      final client = Client(
        idCliente: widget.client?.idCliente ?? provider.generateClientId(),
        nombre: _nombreController.text.trim(),
        apellido: _apellidoController.text.trim(),
        documento: _documentoController.text.trim(),
      );

      widget.onSave(client);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              controller: _nombreController,
              label: 'Nombre *',
              icon: Icons.person,
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'El nombre es obligatorio'
                  : v.trim().length < 2
                      ? 'Debe tener al menos 2 caracteres'
                      : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _apellidoController,
              label: 'Apellido *',
              icon: Icons.person_outline,
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'El apellido es obligatorio'
                  : v.trim().length < 2
                      ? 'Debe tener al menos 2 caracteres'
                      : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _documentoController,
              label: 'Documento *',
              icon: Icons.badge,
              helperText: 'Mínimo 6 caracteres',
              keyboardType: TextInputType.number,
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'El documento es obligatorio'
                  : v.trim().length < 6
                      ? 'Debe tener al menos 6 caracteres'
                      : null,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.onSurface.withOpacity(0.7),
                  ),
                  child: Text('Cancelar'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveClient,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: Text(widget.client == null ? 'Agregar' : 'Actualizar'),
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
    required IconData icon,
    String? helperText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: colorScheme.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        helperText: helperText,
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}