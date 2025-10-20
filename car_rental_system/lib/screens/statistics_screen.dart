import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/car_rental_provider.dart';

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estadísticas'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Forzar reconstrucción de la pantalla
              (context as Element).markNeedsBuild();
            },
          ),
        ],
      ),
      body: Consumer<CarRentalProvider>(
        builder: (context, provider, child) {
          final totalActiveReservations = provider.totalActiveReservations;
          final totalAvailableVehicles = provider.totalAvailableVehicles;
          final clientWithMostReservations = provider.getClientWithMostReservations();
          final totalVehicles = provider.vehicles.length;
          final totalClients = provider.clients.length;
          final totalReservations = provider.reservations.length;
          final totalDeliveries = provider.deliveries.length;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tarjetas principales de estadísticas
                Text(
                  'Resumen General',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                
                // Estadísticas principales requeridas
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Reservas Activas',
                        totalActiveReservations.toString(),
                        Icons.book,
                        Colors.orange,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Vehículos Disponibles',
                        totalAvailableVehicles.toString(),
                        Icons.directions_car,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                
                // Cliente con más reservas
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Cliente con Más Reservas',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        if (clientWithMostReservations != null) ...[
                          Text(
                            clientWithMostReservations.nombreCompleto,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.amber.shade700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Documento: ${clientWithMostReservations.documento}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Total de reservas: ${provider.getReservationCountForClient(clientWithMostReservations.idCliente)}',
                            style: TextStyle(
                              color: Colors.amber.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ] else ...[
                          Text(
                            'No hay datos disponibles',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Estadísticas adicionales
                Text(
                  'Estadísticas Generales',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    _buildStatCard(
                      context,
                      'Total Vehículos',
                      totalVehicles.toString(),
                      Icons.directions_car_filled,
                      Colors.blue,
                    ),
                    _buildStatCard(
                      context,
                      'Total Clientes',
                      totalClients.toString(),
                      Icons.people,
                      Colors.purple,
                    ),
                    _buildStatCard(
                      context,
                      'Total Reservas',
                      totalReservations.toString(),
                      Icons.book_outlined,
                      Colors.indigo,
                    ),
                    _buildStatCard(
                      context,
                      'Total Entregas',
                      totalDeliveries.toString(),
                      Icons.assignment_turned_in,
                      Colors.teal,
                    ),
                  ],
                ),
                
                SizedBox(height: 24),
                
                // Información adicional
                if (totalVehicles > 0) ...[
                  Text(
                    'Detalles de Flota',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            'Vehículos en uso',
                            (totalVehicles - totalAvailableVehicles).toString(),
                            Colors.red,
                          ),
                          Divider(),
                          _buildDetailRow(
                            'Porcentaje de disponibilidad',
                            '${((totalAvailableVehicles / totalVehicles) * 100).toStringAsFixed(1)}%',
                            Colors.green,
                          ),
                          Divider(),
                          _buildDetailRow(
                            'Porcentaje de ocupación',
                            '${(((totalVehicles - totalAvailableVehicles) / totalVehicles) * 100).toStringAsFixed(1)}%',
                            Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                
                SizedBox(height: 16),
                
                // Botones de navegación rápida
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Acciones Rápidas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => Navigator.pushNamed(context, '/vehicles'),
                              icon: Icon(Icons.directions_car),
                              label: Text('Ver Vehículos'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => Navigator.pushNamed(context, '/clients'),
                              icon: Icon(Icons.people),
                              label: Text('Ver Clientes'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => Navigator.pushNamed(context, '/reservations'),
                              icon: Icon(Icons.book),
                              label: Text('Ver Reservas'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => Navigator.pushNamed(context, '/deliveries'),
                              icon: Icon(Icons.assignment_return),
                              label: Text('Ver Entregas'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}