class Vehicle {
  String idVehiculo;
  String marca;
  String modelo;
  int ano;
  bool disponible;

  Vehicle({
    required this.idVehiculo,
    required this.marca,
    required this.modelo,
    required this.ano,
    this.disponible = true,
  });

  // Método para serializar a JSON
  Map<String, dynamic> toJson() {
    return {
      'idVehiculo': idVehiculo,
      'marca': marca,
      'modelo': modelo,
      'ano': ano,
      'disponible': disponible,
    };
  }

  // Método para crear desde JSON
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      idVehiculo: json['idVehiculo'] ?? '',
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
      ano: json['ano'] ?? 0,
      disponible: json['disponible'] ?? true,
    );
  }

  // Getter para mostrar disponibilidad como texto
  String get disponibilidadTexto => disponible ? "Sí" : "No";

  // Método para validar los datos
  bool isValid() {
    return idVehiculo.isNotEmpty && 
           marca.isNotEmpty && 
           modelo.isNotEmpty && 
           ano > 1900 && 
           ano <= DateTime.now().year + 1;
  }

  // Método para copiar con modificaciones
  Vehicle copyWith({
    String? idVehiculo,
    String? marca,
    String? modelo,
    int? ano,
    bool? disponible,
  }) {
    return Vehicle(
      idVehiculo: idVehiculo ?? this.idVehiculo,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      ano: ano ?? this.ano,
      disponible: disponible ?? this.disponible,
    );
  }

  @override
  String toString() {
    return '$marca $modelo ($ano) - ${disponibilidadTexto}';
  }
}