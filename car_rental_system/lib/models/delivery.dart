class Delivery {
  String idEntrega;
  String idReserva;
  DateTime fechaEntregaReal;
  String? observaciones;
  int? kilometrajeFinal;

  Delivery({
    required this.idEntrega,
    required this.idReserva,
    required this.fechaEntregaReal,
    this.observaciones,
    this.kilometrajeFinal,
  });

  // Método para serializar a JSON
  Map<String, dynamic> toJson() {
    return {
      'idEntrega': idEntrega,
      'idReserva': idReserva,
      'fechaEntregaReal': fechaEntregaReal.millisecondsSinceEpoch,
      'observaciones': observaciones,
      'kilometrajeFinal': kilometrajeFinal,
    };
  }

  // Método para crear desde JSON
  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      idEntrega: json['idEntrega'] ?? '',
      idReserva: json['idReserva'] ?? '',
      fechaEntregaReal: DateTime.fromMillisecondsSinceEpoch(json['fechaEntregaReal'] ?? 0),
      observaciones: json['observaciones'],
      kilometrajeFinal: json['kilometrajeFinal'],
    );
  }

  // Método para validar los datos
  bool isValid() {
    return idEntrega.isNotEmpty && 
           idReserva.isNotEmpty &&
           !fechaEntregaReal.isAfter(DateTime.now().add(Duration(hours: 1)));
  }

  // Método para copiar con modificaciones
  Delivery copyWith({
    String? idEntrega,
    String? idReserva,
    DateTime? fechaEntregaReal,
    String? observaciones,
    int? kilometrajeFinal,
  }) {
    return Delivery(
      idEntrega: idEntrega ?? this.idEntrega,
      idReserva: idReserva ?? this.idReserva,
      fechaEntregaReal: fechaEntregaReal ?? this.fechaEntregaReal,
      observaciones: observaciones ?? this.observaciones,
      kilometrajeFinal: kilometrajeFinal ?? this.kilometrajeFinal,
    );
  }

  @override
  String toString() {
    return 'Entrega $idEntrega - Reserva: $idReserva (${fechaEntregaReal.day}/${fechaEntregaReal.month}/${fechaEntregaReal.year})';
  }
}