class MenuModel {
  int id;
  String nombre;
  String url;
  int menuId; // Updated to be nullable
  int orden;
  int moduloId;
  bool migrated;

  MenuModel({
    required this.id,
    required this.nombre,
    required this.url,
    required this.menuId, // Now nullable, so 'required' is removed
    required this.orden,
    required this.moduloId,
    required this.migrated,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'],
      nombre: json['nombre'],
      url: json['url'],
      menuId: json['menu_id'] ?? 0,
      orden: json['orden'],
      moduloId: json['modulo_id'],
      migrated: json['migrated'],
    );
  }

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      id: map['id'],
      nombre: map['nombre'],
      url: map['url'],
      menuId: map['menu_id'] ?? 0,
      orden: map['orden'],
      moduloId: map['modulo_id'],
      migrated: map['migrated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'url': url,
      'menu_id': menuId, // No change needed, nulls are handled correctly
      'orden': orden,
      'modulo_id': moduloId,
      'migrated': migrated,
    };
  }
}