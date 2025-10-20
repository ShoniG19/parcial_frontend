import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sistema de Alquiler de Autos'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        children: [
          _buildMenuCard(
            context,
            'Vehículos',
            Icons.directions_car,
            Colors.blue,
            '/vehicles',
          ),
          _buildMenuCard(
            context,
            'Clientes',
            Icons.people,
            Colors.green,
            '/clients',
          ),
          _buildMenuCard(
            context,
            'Reservas',
            Icons.book,
            Colors.orange,
            '/reservations',
          ),
          _buildMenuCard(
            context,
            'Entregas',
            Icons.assignment_return,
            Colors.purple,
            '/deliveries',
          ),
          _buildMenuCard(
            context,
            'Estadísticas',
            Icons.bar_chart,
            Colors.red,
            '/statistics',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, Color color, String route) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}