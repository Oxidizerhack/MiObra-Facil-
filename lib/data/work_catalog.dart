import '../models/work_item_model.dart';
import 'work_types.dart';

final List<WorkItem> workCatalog = [
  WorkItem(
    category: 'Obra Gruesa',
    items: [
      workTypes['og_replanteo']!,
      workTypes['og_excavacion_manual']!,
      workTypes['og_zapata_hormigon']!,
      workTypes['og_impermeabilizacion_cimientos']!,
      workTypes['og_muro_ladrillo_18']!,
      workTypes['og_muro_ladrillo_soga']!,
      workTypes['og_losa_hormigon']!,
      workTypes['og_cubierta_teja']!,
      workTypes['og_columna_hormigon']!,
      workTypes['og_viga_hormigon']!,
    ],
  ),
  WorkItem(
    category: 'Obra Fina',
    items: [
      workTypes['of_revoque_interior']!,
      workTypes['of_revoque_exterior']!,
      workTypes['of_piso_ceramica']!,
      workTypes['of_revestimiento_ceramica']!,
      workTypes['of_pintura_latex']!,
      workTypes['of_cielo_falso_yeso']!,
      workTypes['of_zocalo_cemento']!,
      workTypes['of_zocalo_ceramica']!,
      workTypes['of_carpinteria_madera']!,
      workTypes['of_carpinteria_aluminio']!,
    ],
  ),
  WorkItem(
    category: 'Instalaciones',
    items: [
      workTypes['in_instalacion_sanitaria']!,
      workTypes['in_instalacion_electrica']!,
      workTypes['in_instalacion_agua']!,
      workTypes['in_camara_inspeccion']!,
      workTypes['in_tanque_agua']!,
      workTypes['in_gas_domiciliario']!,
    ],
  ),
];
