import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/car_rental_provider.dart';
import '../../models/delivery.dart';
import '../../widgets/delivery_form.dart';
import 'delivery_list.dart';
import 'delivery_pending_banner.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {

  void _showDeliveryForm({Delivery? delivery}) {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return AlertDialog(
          title: Text(
            delivery == null ? 'Registrar Entrega' : 'Editar Entrega',
            style: TextStyle(color: colorScheme.primary),
          ),
          content: SingleChildScrollView(
            child: DeliveryForm(
              delivery: delivery,
              onSave: (newDelivery) {
                final provider = Provider.of<CarRentalProvider>(context, listen: false);
                if (delivery == null) {
                  provider.addDelivery(newDelivery);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Entrega registrada exitosamente')),
                  );
                } else {
                  provider.updateDelivery(newDelivery);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Entrega actualizada exitosamente')),
                  );
                }
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  void _deleteDelivery(Delivery delivery) {
    showDialog(
      context: context,
       builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return AlertDialog(
          title: Text(
            'Confirmar eliminación',
            style: TextStyle(color: colorScheme.primary),
          ),
          content: Text('¿Está seguro que desea eliminar la entrega ${delivery.idEntrega}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final provider = Provider.of<CarRentalProvider>(context, listen: false);
                provider.deleteDelivery(delivery.idEntrega);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Entrega eliminada exitosamente')),
                );
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
    final provider = context.watch<CarRentalProvider>();
    final deliveries = provider.deliveries;
    final activeReservations = provider.getActiveReservations();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "Devoluciones",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: colorScheme.onSurface),            
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
              onPressed: () => _showDeliveryForm(),
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
          if (activeReservations.isNotEmpty)
            DeliveryPendingBanner(activeReservations: activeReservations),
          Expanded(
            child: DeliveryList(
              deliveries: deliveries,
              onEdit: _showDeliveryForm,
              onDelete: _deleteDelivery,
              onAddFirst: () => _showDeliveryForm(),
            ),
          ),
        ],
      ),
    );
  }
}