import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/car_rental_provider.dart';
import 'providers/navigation_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/vehicles/vehicle_screen.dart';
import 'screens/clients/client_screen.dart';
import 'screens/reservations/reservation_screen.dart';
import 'screens/deliveries/delivery_screen.dart';
import 'screens/statistics/statistics_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CarRentalProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
      ],
      child: MaterialApp(
        title: 'Sistema de Alquiler de Autos',
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/vehicles': (context) => VehicleScreen(),
          '/clients': (context) => ClientScreen(),
          '/reservations': (context) => ReservationScreen(),
          '/deliveries': (context) => DeliveryScreen(),
          '/statistics': (context) => StatisticsScreen(),
        },
      ),
    );
  }
}