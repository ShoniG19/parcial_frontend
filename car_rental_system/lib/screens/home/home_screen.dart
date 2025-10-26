import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_rental_system/providers/navigation_provider.dart';
import 'package:car_rental_system/screens/vehicles/vehicle_screen.dart';
import 'package:car_rental_system/screens/statistics/statistics_screen.dart';
import 'package:car_rental_system/screens/clients/client_screen.dart';
import 'package:car_rental_system/screens/reservations/reservation_screen.dart';
import 'package:car_rental_system/screens/deliveries/delivery_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _screens = const [
    StatisticsScreen(),
    VehicleScreen(),
    ClientScreen(),
    ReservationScreen(),
    DeliveryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Alquiler de Autos',
              style: TextStyle(color: colorScheme.onPrimary),
            ),
            backgroundColor: colorScheme.primary,
            centerTitle: true,
            elevation: 2,
          ),
          body: _screens[navigationProvider.selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navigationProvider.selectedIndex,
            onTap: (index) => navigationProvider.setSelectedIndex(index),
        selectedItemColor: colorScheme.tertiary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.5),
        backgroundColor: colorScheme.background,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Estadísticas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Vehículos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Clientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Reservas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_return),
            label: 'Devoluciones',
          ),
        ],
      ));
    });
  }
}
