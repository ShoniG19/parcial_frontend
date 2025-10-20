import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/car_rental_provider.dart';
import 'screens/home_screen.dart';
import 'screens/vehicle_screen.dart';
import 'screens/client_screen.dart';
import 'screens/reservation_screen.dart';
import 'screens/delivery_screen.dart';
import 'screens/statistics_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CarRentalProvider(),
      child: MaterialApp(
        title: 'Sistema de Alquiler de Autos',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 4,
          ),
          cardTheme: CardThemeData(
            elevation: 4,
            margin: EdgeInsets.all(8),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
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