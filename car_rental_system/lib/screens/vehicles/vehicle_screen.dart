import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/car_rental_provider.dart';
import '../../models/vehicle.dart';
import '../../widgets/vehicle_form.dart';
import 'vehicle_search_bar.dart';
import 'vehicle_list.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

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

  void _showVehicleForm([Vehicle? vehicle]) {
    showDialog(
      context: context,
      builder: (context) { 
        final colorScheme = Theme.of(context).colorScheme;
        
        return AlertDialog(
          title: Text(
            vehicle == null ? 'Agregar Vehículo' : 'Editar Vehículo',
            style: TextStyle(color: colorScheme.primary),
          ),
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
        );
      },
    );
  }

  void _deleteVehicle(Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return AlertDialog(
          title: Text(
            'Confirmar eliminación',
            style: TextStyle(color: colorScheme.primary),
          ),
          content: Text('¿Está seguro que desea eliminar el vehículo ${vehicle.marca} ${vehicle.modelo}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
              ),
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
    final vehicles = searchController.text.isEmpty
        ? provider.vehicles
        : filteredVehicles;

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "Vehiculos",
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
              onPressed: () => _showVehicleForm(),
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
          VehicleSearchBar(controller: searchController),
          Expanded(
            child: VehicleList(
              vehicles: vehicles,
              onEdit: _showVehicleForm,
              onDelete: _deleteVehicle,
              onAddFirst: () => _showVehicleForm(),
            ),
          ),
        ],
      ),
    );
  }
}
