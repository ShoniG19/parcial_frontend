import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/car_rental_provider.dart';
import '../../widgets/stats_header.dart';
import '../../widgets/top_client_card.dart';
import '../../widgets/stats_grid.dart';
import '../../widgets/fleet_details_card.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "Estadísticas",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: colorScheme.onSurface
              ),
            ),
          ),
        ),
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<CarRentalProvider>(
        builder: (context, provider, _) {
          final totalVehicles = provider.vehicles.length;
          final totalAvailable = provider.totalAvailableVehicles;
          final topClient = provider.getClientWithMostReservations();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatsHeader(
                  totalActiveReservations: provider.totalActiveReservations,
                  totalAvailableVehicles: totalAvailable,
                ),
                const SizedBox(height: 16),

                TopClientCard(
                  client: topClient,
                  reservationCount: topClient != null
                      ? provider.getReservationCountForClient(topClient.idCliente)
                      : 0,
                ),
                const SizedBox(height: 24),

                StatsGrid(
                  totalVehicles: totalVehicles,
                  totalClients: provider.clients.length,
                  totalReservations: provider.reservations.length,
                  totalDeliveries: provider.deliveries.length,
                ),
                const SizedBox(height: 24),

                if (totalVehicles > 0)
                  FleetDetailsCard(
                    totalVehicles: totalVehicles,
                    totalAvailable: totalAvailable,
                  ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}