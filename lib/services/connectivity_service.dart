import 'package:connectivity_plus/connectivity_plus.dart';

/// Servicio para verificar conectividad a internet
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  
  /// Verifica si hay conexión a internet
  Future<bool> hasConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      
      // Sin conexión
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      
      return true;
    } catch (e) {
      print('Error verificando conectividad: $e');
      return false;
    }
  }
  
  /// Verifica si está conectado a WiFi
  Future<bool> isWifi() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult == ConnectivityResult.wifi;
    } catch (e) {
      print('Error verificando WiFi: $e');
      return false;
    }
  }
  
  /// Verifica si está usando datos móviles
  Future<bool> isMobile() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult == ConnectivityResult.mobile;
    } catch (e) {
      print('Error verificando datos móviles: $e');
      return false;
    }
  }
  
  /// Stream de cambios en la conectividad
  Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }
  
  /// Verifica si se puede sincronizar según configuración
  Future<bool> canSync(bool onlyWifi) async {
    if (!await hasConnection()) {
      return false;
    }
    
    if (onlyWifi) {
      return await isWifi();
    }
    
    return true;
  }
  
  /// Obtiene descripción del tipo de conexión
  Future<String> getConnectionType() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      
      if (connectivityResult == ConnectivityResult.wifi) {
        return 'WiFi';
      } else if (connectivityResult == ConnectivityResult.mobile) {
        return 'Datos móviles';
      } else if (connectivityResult == ConnectivityResult.ethernet) {
        return 'Ethernet';
      } else {
        return 'Sin conexión';
      }
    } catch (e) {
      return 'Desconocido';
    }
  }
}
