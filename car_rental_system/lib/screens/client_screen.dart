import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/car_rental_provider.dart';
import '../models/client.dart';
import '../widgets/client_form.dart';

class ClientScreen extends StatefulWidget {
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

  void _showClientForm({Client? client}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(client == null ? 'Agregar Cliente' : 'Editar Cliente'),
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
      ),
    );
  }

  void _deleteClient(Client client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Está seguro que desea eliminar a ${client.nombreCompleto}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
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
        title: Text('Administración de Clientes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showClientForm(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o documento...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),
          // Lista de clientes
          Expanded(
            child: Consumer<CarRentalProvider>(
              builder: (context, provider, child) {
                final clients = searchController.text.isEmpty 
                    ? provider.clients 
                    : filteredClients;

                if (clients.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          searchController.text.isEmpty 
                              ? 'No hay clientes registrados'
                              : 'No se encontraron clientes',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        if (searchController.text.isEmpty) ...[
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _showClientForm(),
                            child: Text('Agregar Primer Cliente'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: clients.length,
                  itemBuilder: (context, index) {
                    final client = clients[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            client.nombre[0].toUpperCase(),
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          client.nombreCompleto,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Documento: ${client.documento}'),
                            SizedBox(height: 4),
                            Consumer<CarRentalProvider>(
                              builder: (context, provider, child) {
                                final reservationCount = provider.getReservationCountForClient(client.idCliente);
                                return Text(
                                  'Reservas: $reservationCount',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            switch (value) {
                              case 'edit':
                                _showClientForm(client: client);
                                break;
                              case 'delete':
                                _deleteClient(client);
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text('Editar'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Eliminar'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showClientForm(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}