import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/client.dart';
import '../providers/car_rental_provider.dart';

class ClientForm extends StatefulWidget {
  final Client? client;
  final Function(Client) onSave;

  const ClientForm({
    Key? key,
    this.client,
    required this.onSave,
  }) : super(key: key);

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
      
      // Verificar si el documento ya existe (solo para clientes nuevos o si cambió el documento)
      final existingClient = provider.clients.where((c) => 
          c.documento == _documentoController.text && 
          c.idCliente != (widget.client?.idCliente ?? '')).firstOrNull;
      
      if (existingClient != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ya existe un cliente con este documento'),
            backgroundColor: Colors.red,
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
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El nombre es obligatorio';
                }
                if (value.trim().length < 2) {
                  return 'El nombre debe tener al menos 2 caracteres';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _apellidoController,
              decoration: InputDecoration(
                labelText: 'Apellido *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El apellido es obligatorio';
                }
                if (value.trim().length < 2) {
                  return 'El apellido debe tener al menos 2 caracteres';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _documentoController,
              decoration: InputDecoration(
                labelText: 'Documento *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
                helperText: 'Mínimo 6 caracteres',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El documento es obligatorio';
                }
                if (value.trim().length < 6) {
                  return 'El documento debe tener al menos 6 caracteres';
                }
                return null;
              },
              keyboardType: TextInputType.number,
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
                  onPressed: _saveClient,
                  child: Text(widget.client == null ? 'Agregar' : 'Actualizar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}