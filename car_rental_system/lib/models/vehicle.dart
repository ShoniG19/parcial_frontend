class Vehicle {
  String idVehiculo;
  String marca;
  String modelo;
  int anho;
  bool disponible;

  Vehicle({
    required this.idVehiculo,
    required this.marca,
    required this.modelo,
    required this.anho,
    this.disponible = true,
  });

  // Método para serializar a JSON
  Map<String, dynamic> toJson() {
    return {
      'idVehiculo': idVehiculo,
      'marca': marca,
      'modelo': modelo,
      'anho': anho,
      'disponible': disponible,
    };
  }

  // Método para crear desde JSON
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      idVehiculo: json['idVehiculo'] ?? '',
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
      anho: json['anho'] ?? 0,
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
           anho > 1900 && 
           anho <= DateTime.now().year + 1;
  }

  // Método para copiar con modificaciones
  Vehicle copyWith({
    String? idVehiculo,
    String? marca,
    String? modelo,
    int? anho,
    bool? disponible,
  }) {
    return Vehicle(
      idVehiculo: idVehiculo ?? this.idVehiculo,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      anho: anho ?? this.anho,
      disponible: disponible ?? this.disponible,
    );
  }

  @override
  String toString() {
    return '$marca $modelo ($anho) - $disponibilidadTexto';
  }
}