import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/car_rental_provider.dart';
import '../../models/client.dart';
import '../../widgets/client_form.dart';
import 'client_list.dart';
import 'client_search_bar.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  TextEditingController searchController = TextEditingController();
  List<Client> filteredClients = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterClients);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterClients() {
    final provider = Provider.of<CarRentalProvider>(context, listen: false);
    setState(() {
      filteredClients = provider.filterClients(searchController.text);
    });
  }

  void _showClientForm([Client? client]) {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: Text(
            client == null ? 'Agregar Cliente' : 'Editar Cliente',
            style: TextStyle(color: colorScheme.primary),
          ),
          content: SingleChildScrollView(
            child: ClientForm(
              client: client,
              onSave: (newClient) {
                final provider = Provider.of<CarRentalProvider>(context, listen: false);
                if (client == null) {
                  provider.addClient(newClient);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cliente agregado exitosamente')),
                  );
                } else {
                  provider.updateClient(newClient);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cliente actualizado exitosamente')),
                  );
                }
                Navigator.pop(context);
                _filterClients();
              },
            ),
          ),
        );
      },
    );
  }

  void _deleteClient(Client client) {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return AlertDialog(
          title: Text(
            'Confirmar eliminación',
            style: TextStyle(color: colorScheme.primary),
          ),
        content: Text('¿Está seguro que desea eliminar a ${client.nombreCompleto}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7))),
          ),
          ElevatedButton(
            onPressed: () {
              final provider = Provider.of<CarRentalProvider>(context, listen: false);
              provider.deleteClient(client.idCliente);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cliente eliminado exitosamente')),
              );
              _filterClients();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: Text('Eliminar'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final provider = context.watch<CarRentalProvider>();
    final clients = searchController.text.isEmpty
        ? provider.clients
        : filteredClients;

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "Clientes",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ),
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () => _showClientForm(),
              icon: const Icon(Icons.add),
              label: Text('Agregar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ClientSearchBar(controller: searchController),
          Expanded(
            child: ClientList(
              clients: clients,
              onEdit: _showClientForm,
              onDelete: _deleteClient,
              onAddFirst: () => _showClientForm(),
            ),
          ),
        ],
      ),
    );
  }
}