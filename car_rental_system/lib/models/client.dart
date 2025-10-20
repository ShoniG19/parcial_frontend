class Client {
  String idCliente;
  String nombre;
  String apellido;
  String documento;

  Client({
    required this.idCliente,
    required this.nombre,
    required this.apellido,
    required this.documento,
  });

  // Método para serializar a JSON
  Map<String, dynamic> toJson() {
    return {
      'idCliente': idCliente,
      'nombre': nombre,
      'apellido': apellido,
      'documento': documento,
    };
  }

  // Método para crear desde JSON
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      idCliente: json['idCliente'] ?? '',
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      documento: json['documento'] ?? '',
    );
  }

  // Getter para nombre completo
  String get nombreCompleto => '$nombre $apellido';

  // Método para validar los datos
  bool isValid() {
    return idCliente.isNotEmpty && 
           nombre.isNotEmpty && 
           apellido.isNotEmpty && 
           documento.isNotEmpty &&
           documento.length >= 6; // Mínimo 6 caracteres para documento
  }

  // Método para copiar con modificaciones
  Client copyWith({
    String? idCliente,
    String? nombre,
    String? apellido,
    String? documento,
  }) {
    return Client(
      idCliente: idCliente ?? this.idCliente,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      documento: documento ?? this.documento,
    );
  }

  @override
  String toString() {
    return '$nombreCompleto (Doc: $documento)';
  }
}