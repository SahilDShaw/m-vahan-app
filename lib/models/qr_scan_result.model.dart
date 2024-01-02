import '../enums/qr_type.enum.dart';
import 'driver_data.model.dart';
import 'vehicle_data.model.dart';

class QRScanResult {
  QRType qrType;
  dynamic data;

  QRScanResult({
    required this.qrType,
    required this.data,
  });

  factory QRScanResult.fromJSON(Map<String, dynamic> json) {
    QRType qrType = QRType.none;
    dynamic data;

    if (json['qr_type'] == 'vehicle') {
      qrType = QRType.vehicle;
      data = VehicleData.fromJson(json['data']);
    } else if (json['qr_type'] == 'driver') {
      qrType = QRType.driver;
      data = DriverData.fromJson(json['data']);
    } else {
      data = 'Invalid Data!';
    }

    return QRScanResult(
      qrType: qrType,
      data: data,
    );
  }
}
