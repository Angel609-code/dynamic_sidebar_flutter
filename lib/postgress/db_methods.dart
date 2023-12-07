import 'package:dynamic_sidebar/models/menu_model.dart';
import 'package:postgres/postgres.dart';

Future<List<MenuModel>> fetchMenuData(String user, String filter) async {
  final connection = await Connection.open(
    Endpoint(
      host: 'localhost',
      database: 'planilla',
      username: 'postgres',
      password: 'Postgres321*',
    ),
    // The postgres server hosted locally doesn't have SSL by default. If you're
    // accessing a postgres server over the Internet, the server should support
    // SSL and you should swap out the mode with `SslMode.verifyFull`.
    settings: const ConnectionSettings(sslMode: SslMode.disable),
  );

  String query = '''with recursive filtered_menu AS (
      (SELECT 99990+mo.id AS id, mo.nombre, '/' AS url, NULL AS menu_id, 1 AS orden, 0 AS modulo_id, FALSE AS migrated
       FROM seguridad.modulo mo WHERE mo.pasivo = FALSE AND CASE WHEN '%%' = '$filter' THEN TRUE ELSE FALSE END) 
       
       UNION all
       
      (SELECT m.id,
       m.nombre, r.url, m.menu_id, m.orden, m.modulo_id, r.migrado as migrated FROM public.auth_users au
       INNER JOIN seguridad.permiso p ON p.usuario_id = au.usr_id INNER JOIN seguridad.rol_menu rm ON rm.rol_id = p.rol_id
       INNER JOIN seguridad.menu m ON m.id = rm.menu_id INNER JOIN seguridad.recurso r ON r.id = m.recurso_id
       WHERE au.usr_login = '$user' AND m.pasivo = FALSE AND m.nombre ILIKE '$filter' AND r.url <> '/' ORDER BY m.modulo_id,
       CASE WHEN m.menu_id IS NULL THEN 0 ELSE 1 END, menu_id, orden)
      ) , related_menus AS (
            SELECT fm.id, fm.nombre, fm.url, fm.menu_id, fm.orden, fm.modulo_id, fm.migrated
            FROM filtered_menu as fm
            UNION
            SELECT m.id, m.nombre, r.url, m.menu_id, m.orden, m.modulo_id, r.migrado as migrated
            FROM public.auth_users au
            INNER JOIN seguridad.permiso p ON p.usuario_id = au.usr_id
            INNER JOIN seguridad.rol_menu rm ON rm.rol_id = p.rol_id
            INNER JOIN seguridad.menu m ON m.id = rm.menu_id
            INNER JOIN seguridad.recurso r ON r.id = m.recurso_id
            INNER JOIN related_menus rm2 ON rm2.menu_id = m.id
            WHERE au.usr_login = '$user' AND m.pasivo = FALSE
        ) SELECT 99990+mo.id AS id, mo.nombre, '/' AS url, NULL AS menu_id, 1 AS orden, 0 AS modulo_id, FALSE AS migrated
    FROM seguridad.modulo mo 
    WHERE mo.pasivo = false 
    AND CASE WHEN '%%' = '$filter' THEN false ELSE true END
    AND EXISTS (
        SELECT 1
        FROM related_menus as rm
        WHERE rm.modulo_id = mo.id
    )
    UNION all 
    SELECT rm.id, rm.nombre, rm.url, rm.menu_id, rm.orden, rm.modulo_id, rm.migrated
    FROM related_menus as rm;''';

  final results = await connection.execute(
    query,
  );

  final List<MenuModel> menuModel = results
      .map((row) => MenuModel.fromMap(row.toColumnMap()))
      .toList();

  await connection.close();

  return menuModel;
}