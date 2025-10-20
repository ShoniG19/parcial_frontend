import 'package:flutter/foundation.dart';
import '../models/vehicle.dart';
import '../models/client.dart';
import '../models/reservation.dart';
import '../models/delivery.dart';

class CarRentalProvider extends ChangeNotifier {
  // Listas para almacenar los datos
  final List<Vehicle> _vehicles = [];
  final List<Client> _clients = [];
  final List<Reservation> _reservations = [];
  final List<Delivery> _deliveries = [];

  // Getters para acceder a los datos (solo lectura)
  List<Vehicle> get vehicles => List.unmodifiable(_vehicles);
  List<Client> get clients => List.unmodifiable(_clients);
  List<Reservation> get reservations => List.unmodifiable(_reservations);
  List<Delivery> get deliveries => List.unmodifiable(_deliveries);

  // Constructor que inicializa con datos de ejemplo
  CarRentalProvider() {
    _initializeData();
  }

  void _initializeData() {
    // Datos de ejemplo
    _vehicles.addAll([
      Vehicle(idVehiculo: '1', marca: 'Toyota', modelo: 'Corolla', ano: 2020, disponible: true),
      Vehicle(idVehiculo: '2', marca: 'Honda', modelo: 'Civic', ano: 2021, disponible: false),
      Vehicle(idVehiculo: '3', marca: 'Ford', modelo: 'Focus', ano: 2019, disponible: true),
      Vehicle(idVehiculo: '4', marca: 'Chevrolet', modelo: 'Cruze', ano: 2022, disponible: true),
    ]);

    _clients.addAll([
      Client(idCliente: '1', nombre: 'Juan', apellido: 'Pérez', documento: '12345678'),
      Client(idCliente: '2', nombre: 'María', apellido: 'González', documento: '87654321'),
      Client(idCliente: '3', nombre: 'Carlos', apellido: 'López', documento: '11223344'),
    ]);

    _reservations.addAll([
      Reservation(
        idReserva: '1',
        idCliente: '1',
        idVehiculo: '2',
        fechaInicio: DateTime.now().subtract(Duration(days: 2)),
        fechaFin: DateTime.now().add(Duration(days: 3)),
        activa: true,
      ),
    ]);
  }

  // CRUD Vehículos
  void addVehicle(Vehicle vehicle) {
    _vehicles.add(vehicle);
    notifyListeners();
  }

  void updateVehicle(Vehicle updatedVehicle) {
    final index = _vehicles.indexWhere((v) => v.idVehiculo == updatedVehicle.idVehiculo);
    if (index != -1) {
      _vehicles[index] = updatedVehicle;
      notifyListeners();
    }
  }

  void deleteVehicle(String idVehiculo) {
    _vehicles.removeWhere((v) => v.idVehiculo == idVehiculo);
    notifyListeners();
  }

  Vehicle? getVehicleById(String id) {
    try {
      return _vehicles.firstWhere((v) => v.idVehiculo == id);
    } catch (e) {
      return null;
    }
  }

  List<Vehicle> getAvailableVehicles() {
    return _vehicles.where((v) => v.disponible).toList();
  }

  List<Vehicle> filterVehicles(String query) {
    if (query.isEmpty) return _vehicles;
    return _vehicles.where((vehicle) {
      return vehicle.marca.toLowerCase().contains(query.toLowerCase()) ||
          vehicle.modelo.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // CRUD Clientes
  void addClient(Client client) {
    _clients.add(client);
    notifyListeners();
  }

  void updateClient(Client updatedClient) {
    final index = _clients.indexWhere((c) => c.idCliente == updatedClient.idCliente);
    if (index != -1) {
      _clients[index] = updatedClient;
      notifyListeners();
    }
  }

  void deleteClient(String idCliente) {
    _clients.removeWhere((c) => c.idCliente == idCliente);
    notifyListeners();
  }

  Client? getClientById(String id) {
    try {
      return _clients.firstWhere((c) => c.idCliente == id);
    } catch (e) {
      return null;
    }
  }

  List<Client> filterClients(String query) {
    if (query.isEmpty) return _clients;
    return _clients.where((client) {
      return client.nombre.toLowerCase().contains(query.toLowerCase()) ||
          client.apellido.toLowerCase().contains(query.toLowerCase()) ||
          client.documento.contains(query);
    }).toList();
  }

  // CRUD Reservas
  void addReservation(Reservation reservation) {
    _reservations.add(reservation);
    // Marcar vehículo como no disponible
    final vehicle = getVehicleById(reservation.idVehiculo);
    if (vehicle != null) {
      updateVehicle(vehicle.copyWith(disponible: false));
    }
    notifyListeners();
  }

  void updateReservation(Reservation updatedReservation) {
    final index = _reservations.indexWhere((r) => r.idReserva == updatedReservation.idReserva);
    if (index != -1) {
      _reservations[index] = updatedReservation;
      notifyListeners();
    }
  }

  void deleteReservation(String idReserva) {
    final reservation = getReservationById(idReserva);
    if (reservation != null) {
      // Marcar vehículo como disponible nuevamente
      final vehicle = getVehicleById(reservation.idVehiculo);
      if (vehicle != null) {
        updateVehicle(vehicle.copyWith(disponible: true));
      }
    }
    _reservations.removeWhere((r) => r.idReserva == idReserva);
    notifyListeners();
  }

  Reservation? getReservationById(String id) {
    try {
      return _reservations.firstWhere((r) => r.idReserva == id);
    } catch (e) {
      return null;
    }
  }

  List<Reservation> getActiveReservations() {
    return _reservations.where((r) => r.activa).toList();
  }

  // CRUD Entregas
  void addDelivery(Delivery delivery) {
    _deliveries.add(delivery);
    // Marcar reserva como finalizada y vehículo como disponible
    final reservation = getReservationById(delivery.idReserva);
    if (reservation != null) {
      updateReservation(reservation.copyWith(activa: false));
      final vehicle = getVehicleById(reservation.idVehiculo);
      if (vehicle != null) {
        updateVehicle(vehicle.copyWith(disponible: true));
      }
    }
    notifyListeners();
  }

  void updateDelivery(Delivery updatedDelivery) {
    final index = _deliveries.indexWhere((d) => d.idEntrega == updatedDelivery.idEntrega);
    if (index != -1) {
      _deliveries[index] = updatedDelivery;
      notifyListeners();
    }
  }

  void deleteDelivery(String idEntrega) {
    _deliveries.removeWhere((d) => d.idEntrega == idEntrega);
    notifyListeners();
  }

  // Estadísticas
  int get totalActiveReservations => getActiveReservations().length;
  
  int get totalAvailableVehicles => getAvailableVehicles().length;

  Client? getClientWithMostReservations() {
    if (_clients.isEmpty || _reservations.isEmpty) return null;
    
    Map<String, int> clientReservationCount = {};
    
    for (var reservation in _reservations) {
      clientReservationCount[reservation.idCliente] = 
          (clientReservationCount[reservation.idCliente] ?? 0) + 1;
    }
    
    if (clientReservationCount.isEmpty) return null;
    
    String topClientId = clientReservationCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    
    return getClientById(topClientId);
  }

  int getReservationCountForClient(String clientId) {
    return _reservations.where((r) => r.idCliente == clientId).length;
  }

  // Generar IDs únicos
  String generateVehicleId() {
    int maxId = 0;
    for (var vehicle in _vehicles) {
      int? id = int.tryParse(vehicle.idVehiculo);
      if (id != null && id > maxId) {
        maxId = id;
      }
    }
    return (maxId + 1).toString();
  }

  String generateClientId() {
    int maxId = 0;
    for (var client in _clients) {
      int? id = int.tryParse(client.idCliente);
      if (id != null && id > maxId) {
        maxId = id;
      }
    }
    return (maxId + 1).toString();
  }

  String generateReservationId() {
    int maxId = 0;
    for (var reservation in _reservations) {
      int? id = int.tryParse(reservation.idReserva);
      if (id != null && id > maxId) {
        maxId = id;
      }
    }
    return (maxId + 1).toString();
  }

  String generateDeliveryId() {
    int maxId = 0;
    for (var delivery in _deliveries) {
      int? id = int.tryParse(delivery.idEntrega);
      if (id != null && id > maxId) {
        maxId = id;
      }
    }
    return (maxId + 1).toString();
  }
}