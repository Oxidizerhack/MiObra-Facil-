import '../models/work_type_model.dart';

final Map<String, WorkType> workTypes = {
  // OBRA GRUESA
  'og_replanteo': WorkType(id: 'og_replanteo', description: 'Replanteo y Trazado', unit: 'm2', prices: {'laPaz': 10.46, 'cochabamba': 11.00, 'santaCruz': 12.50, 'sucre': 10.80, 'oruro': 10.20, 'tarija': 11.50, 'potosi': 9.80}),
  'og_excavacion_manual': WorkType(id: 'og_excavacion_manual', description: 'Excavación manual 0 a 2m', unit: 'm3', prices: {'laPaz': 83.69, 'cochabamba': 85.00, 'santaCruz': 90.00, 'sucre': 84.50, 'oruro': 82.00, 'tarija': 87.00, 'potosi': 80.00}),
  'og_zapata_hormigon': WorkType(id: 'og_zapata_hormigon', description: 'Zapata de H°C°', unit: 'm3', prices: {'laPaz': 251.08, 'cochabamba': 255.00, 'santaCruz': 260.00, 'sucre': 253.00, 'oruro': 248.00, 'tarija': 258.00, 'potosi': 245.00}),
  'og_impermeabilizacion_cimientos': WorkType(id: 'og_impermeabilizacion_cimientos', description: 'Impermeabilización de cimientos', unit: 'm2', prices: {'laPaz': 33.48, 'cochabamba': 35.00, 'santaCruz': 38.00, 'sucre': 34.50, 'oruro': 32.80, 'tarija': 36.50, 'potosi': 31.50}),
  'og_muro_ladrillo_18': WorkType(id: 'og_muro_ladrillo_18', description: 'Muro de Ladrillo 18h', unit: 'm2', prices: {'laPaz': 79.51, 'cochabamba': 82.00, 'santaCruz': 85.00, 'sucre': 80.50, 'oruro': 78.00, 'tarija': 83.50, 'potosi': 76.00}),
  'og_muro_ladrillo_soga': WorkType(id: 'og_muro_ladrillo_soga', description: 'Muro de Ladrillo (soga)', unit: 'm2', prices: {'laPaz': 54.40, 'cochabamba': 56.00, 'santaCruz': 58.00, 'sucre': 55.20, 'oruro': 53.50, 'tarija': 57.00, 'potosi': 52.00}),
  'og_losa_hormigon': WorkType(id: 'og_losa_hormigon', description: 'Losa de H°A°', unit: 'm3', prices: {'laPaz': 334.78, 'cochabamba': 340.00, 'santaCruz': 350.00, 'sucre': 337.00, 'oruro': 330.00, 'tarija': 345.00, 'potosi': 325.00}),
  'og_cubierta_teja': WorkType(id: 'og_cubierta_teja', description: 'Cubierta de teja', unit: 'm2', prices: {'laPaz': 91.00, 'cochabamba': 95.00, 'santaCruz': 100.00, 'sucre': 93.00, 'oruro': 89.00, 'tarija': 97.00, 'potosi': 86.00}),
  'og_columna_hormigon': WorkType(id: 'og_columna_hormigon', description: 'Columna de H°A°', unit: 'm3', prices: {'laPaz': 418.47, 'cochabamba': 425.00, 'santaCruz': 430.00, 'sucre': 421.00, 'oruro': 415.00, 'tarija': 428.00, 'potosi': 410.00}),
  'og_viga_hormigon': WorkType(id: 'og_viga_hormigon', description: 'Viga de H°A°', unit: 'm3', prices: {'laPaz': 418.47, 'cochabamba': 425.00, 'santaCruz': 430.00, 'sucre': 421.00, 'oruro': 415.00, 'tarija': 428.00, 'potosi': 410.00}),
  
  // OBRA FINA
  'of_revoque_interior': WorkType(id: 'of_revoque_interior', description: 'Revoque interior de Yeso', unit: 'm2', prices: {'laPaz': 27.90, 'cochabamba': 29.00, 'santaCruz': 32.00, 'sucre': 28.50, 'oruro': 27.00, 'tarija': 30.50, 'potosi': 26.00}),
  'of_revoque_exterior': WorkType(id: 'of_revoque_exterior', description: 'Revoque exterior con cemento', unit: 'm2', prices: {'laPaz': 36.83, 'cochabamba': 38.00, 'santaCruz': 42.00, 'sucre': 37.50, 'oruro': 36.00, 'tarija': 40.00, 'potosi': 35.00}),
  'of_piso_ceramica': WorkType(id: 'of_piso_ceramica', description: 'Piso de Cerámica', unit: 'm2', prices: {'laPaz': 41.85, 'cochabamba': 45.00, 'santaCruz': 48.00, 'sucre': 43.50, 'oruro': 40.50, 'tarija': 46.50, 'potosi': 39.00}),
  'of_revestimiento_ceramica': WorkType(id: 'of_revestimiento_ceramica', description: 'Revestimiento de cerámica', unit: 'm2', prices: {'laPaz': 50.22, 'cochabamba': 53.00, 'santaCruz': 56.00, 'sucre': 51.50, 'oruro': 49.00, 'tarija': 54.50, 'potosi': 47.50}),
  'of_pintura_latex': WorkType(id: 'of_pintura_latex', description: 'Pintura latex interior/exterior', unit: 'm2', prices: {'laPaz': 16.74, 'cochabamba': 18.00, 'santaCruz': 20.00, 'sucre': 17.50, 'oruro': 16.00, 'tarija': 19.00, 'potosi': 15.50}),
  'of_cielo_falso_yeso': WorkType(id: 'of_cielo_falso_yeso', description: 'Cielo falso de yeso', unit: 'm2', prices: {'laPaz': 58.58, 'cochabamba': 60.00, 'santaCruz': 65.00, 'sucre': 59.50, 'oruro': 57.00, 'tarija': 63.00, 'potosi': 55.00}),
  'of_zocalo_cemento': WorkType(id: 'of_zocalo_cemento', description: 'Zócalo de cemento', unit: 'ml', prices: {'laPaz': 13.39, 'cochabamba': 15.00, 'santaCruz': 17.00, 'sucre': 14.20, 'oruro': 13.00, 'tarija': 16.00, 'potosi': 12.50}),
  'of_zocalo_ceramica': WorkType(id: 'of_zocalo_ceramica', description: 'Zócalo de cerámica', unit: 'ml', prices: {'laPaz': 20.92, 'cochabamba': 22.00, 'santaCruz': 25.00, 'sucre': 21.50, 'oruro': 20.00, 'tarija': 23.50, 'potosi': 19.50}),
  'of_carpinteria_madera': WorkType(id: 'of_carpinteria_madera', description: 'Carpintería de Madera (Puertas)', unit: 'pza', prices: {'laPaz': 700.00, 'cochabamba': 750.00, 'santaCruz': 800.00, 'sucre': 725.00, 'oruro': 680.00, 'tarija': 775.00, 'potosi': 650.00}),
  'of_carpinteria_aluminio': WorkType(id: 'of_carpinteria_aluminio', description: 'Carpintería de Aluminio (Ventanas)', unit: 'm2', prices: {'laPaz': 279.00, 'cochabamba': 290.00, 'santaCruz': 310.00, 'sucre': 285.00, 'oruro': 275.00, 'tarija': 300.00, 'potosi': 270.00}),

  // INSTALACIONES
  'in_instalacion_sanitaria': WorkType(id: 'in_instalacion_sanitaria', description: 'Instalación Sanitaria (Punto)', unit: 'pto', prices: {'laPaz': 209.24, 'cochabamba': 215.00, 'santaCruz': 225.00, 'sucre': 212.00, 'oruro': 205.00, 'tarija': 220.00, 'potosi': 200.00}),
  'in_instalacion_electrica': WorkType(id: 'in_instalacion_electrica', description: 'Instalación Eléctrica (Punto)', unit: 'pto', prices: {'laPaz': 139.49, 'cochabamba': 145.00, 'santaCruz': 155.00, 'sucre': 142.00, 'oruro': 137.00, 'tarija': 150.00, 'potosi': 135.00}),
  'in_instalacion_agua': WorkType(id: 'in_instalacion_agua', description: 'Instalación de Agua Potable (Punto)', unit: 'pto', prices: {'laPaz': 167.39, 'cochabamba': 175.00, 'santaCruz': 185.00, 'sucre': 171.00, 'oruro': 165.00, 'tarija': 180.00, 'potosi': 162.00}),
  'in_camara_inspeccion': WorkType(id: 'in_camara_inspeccion', description: 'Cámara de Inspección', unit: 'pza', prices: {'laPaz': 278.98, 'cochabamba': 285.00, 'santaCruz': 295.00, 'sucre': 282.00, 'oruro': 275.00, 'tarija': 290.00, 'potosi': 270.00}),
  'in_tanque_agua': WorkType(id: 'in_tanque_agua', description: 'Tanque de agua 1000 lts', unit: 'pza', prices: {'laPaz': 1115.93, 'cochabamba': 1150.00, 'santaCruz': 1200.00, 'sucre': 1130.00, 'oruro': 1100.00, 'tarija': 1175.00, 'potosi': 1080.00}),
  'in_gas_domiciliario': WorkType(id: 'in_gas_domiciliario', description: 'Instalación de Gas Domiciliario (Punto)', unit: 'pto', prices: {'laPaz': 250.00, 'cochabamba': 260.00, 'santaCruz': 280.00, 'sucre': 255.00, 'oruro': 245.00, 'tarija': 270.00, 'potosi': 240.00}),
};

