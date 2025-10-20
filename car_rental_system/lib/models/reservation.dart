class Reservation {
  String idReserva;
  String idCliente;
  String idVehiculo;
  DateTime fechaInicio;
  DateTime fechaFin;
  bool activa; // Para saber si la reserva está activa o ya fue entregada

  Reservation({
    required this.idReserva,
    required this.idCliente,
    required this.idVehiculo,
    required this.fechaInicio,
    required this.fechaFin,
    this.activa = true,
  });

  // Método para serializar a JSON
  Map<String, dynamic> toJson() {
    return {
      'idReserva': idReserva,
      'idCliente': idCliente,
      'idVehiculo': idVehiculo,
      'fechaInicio': fechaInicio.millisecondsSinceEpoch,
      'fechaFin': fechaFin.millisecondsSinceEpoch,
      'activa': activa,
    };
  }

  // Método para crear desde JSON
  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      idReserva: json['idReserva'] ?? '',
      idCliente: json['idCliente'] ?? '',
      idVehiculo: json['idVehiculo'] ?? '',
      fechaInicio: DateTime.fromMillisecondsSinceEpoch(json['fechaInicio'] ?? 0),
      fechaFin: DateTime.fromMillisecondsSinceEpoch(json['fechaFin'] ?? 0),
      activa: json['activa'] ?? true,
    );
  }

  // Getter para duración en días
  int get duracionDias => fechaFin.difference(fechaInicio).inDays + 1;

  // Método para validar los datos
  bool isValid() {
    return idReserva.isNotEmpty && 
           idCliente.isNotEmpty && 
           idVehiculo.isNotEmpty && 
           fechaInicio.isBefore(fechaFin) &&
           !fechaFin.isBefore(DateTime.now().subtract(Duration(days: 1)));
  }

  // Verificar si la reserva está vencida
  bool get isVencida => DateTime.now().isAfter(fechaFin) && activa;

  // Verificar si la reserva está en curso
  bool get enCurso {
    final now = DateTime.now();
    return activa && 
           now.isAfter(fechaInicio.subtract(Duration(days: 1))) && 
           now.isBefore(fechaFin.add(Duration(days: 1)));
  }

  // Método para copiar con modificaciones
  Reservation copyWith({
    String? idReserva,
    String? idCliente,
    String? idVehiculo,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    bool? activa,
  }) {
    return Reservation(
      idReserva: idReserva ?? this.idReserva,
      idCliente: idCliente ?? this.idCliente,
      idVehiculo: idVehiculo ?? this.idVehiculo,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      activa: activa ?? this.activa,
    );
  }

  @override
  String toString() {
    return 'Reserva $idReserva: ${fechaInicio.day}/${fechaInicio.month} - ${fechaFin.day}/${fechaFin.month} (${activa ? "Activa" : "Finalizada"})';
  }
}