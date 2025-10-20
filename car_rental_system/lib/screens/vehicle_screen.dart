import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/car_rental_provider.dart';
import '../models/vehicle.dart';
import '../widgets/vehicle_form.dart';

class VehicleScreen extends StatefulWidget {
  @override
  _VehicleScreenState createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  TextEditingController searchController = TextEditingController();
  List<Vehicle> filteredVehicles = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterVehicles);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterVehicles() {
    final provider = Provider.of<CarRentalProvider>(context, listen: false);
    setState(() {
      filteredVehicles = provider.filterVehicles(searchController.text);
    });
  }

  void _showVehicleForm({Vehicle? vehicle}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(vehicle == null ? 'Agregar Vehículo' : 'Editar Vehículo'),
        content: SingleChildScrollView(
          child: VehicleForm(
            vehicle: vehicle,
            onSave: (newVehicle) {
              final provider = Provider.of<CarRentalProvider>(context, listen: false);
              if (vehicle == null) {
                provider.addVehicle(newVehicle);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Vehículo agregado exitosamente')),
                );
              } else {
                provider.updateVehicle(newVehicle);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Vehículo actualizado exitosamente')),
                );
              }
              Navigator.pop(context);
              _filterVehicles();
            },
          ),
        ),
      ),
    );
  }

  void _deleteVehicle(Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Está seguro que desea eliminar el vehículo ${vehicle.marca} ${vehicle.modelo}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final provider = Provider.of<CarRentalProvider>(context, listen: false);
              provider.deleteVehicle(vehicle.idVehiculo);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Vehículo eliminado exitosamente')),
              );
              _filterVehicles();
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
        title: Text('Gestión de Vehículos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showVehicleForm(),
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
                hintText: 'Buscar por marca o modelo...',
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
          // Lista de vehículos
          Expanded(
            child: Consumer<CarRentalProvider>(
              builder: (context, provider, child) {
                final vehicles = searchController.text.isEmpty 
                    ? provider.vehicles 
                    : filteredVehicles;

                if (vehicles.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_car_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          searchController.text.isEmpty 
                              ? 'No hay vehículos registrados'
                              : 'No se encontraron vehículos',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        if (searchController.text.isEmpty) ...[
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _showVehicleForm(),
                            child: Text('Agregar Primer Vehículo'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: vehicle.disponible ? Colors.green : Colors.red,
                          child: Icon(
                            Icons.directions_car,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          '${vehicle.marca} ${vehicle.modelo}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Año: ${vehicle.ano}'),
                            SizedBox(height: 4),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: vehicle.disponible ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                vehicle.disponibilidadTexto,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            switch (value) {
                              case 'edit':
                                _showVehicleForm(vehicle: vehicle);
                                break;
                              case 'delete':
                                _deleteVehicle(vehicle);
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
        onPressed: () => _showVehicleForm(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}