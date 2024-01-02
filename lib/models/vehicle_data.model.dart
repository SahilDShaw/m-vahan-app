class VehicleData {
  String vehicleNo;
  String manufacturer;
  String model;
  String variant;
  int age;
  int kmsDriven;
  String registrationCity;

  VehicleData({
    required this.vehicleNo,
    required this.manufacturer,
    required this.model,
    required this.variant,
    required this.age,
    required this.kmsDriven,
    required this.registrationCity,
  });

  factory VehicleData.fromJson(Map<String, dynamic> json) {
    return VehicleData(
      vehicleNo: json['vehicle_no'],
      manufacturer: json['manufacturer'],
      model: json['model'],
      variant: json['variant'],
      age: json['age'],
      kmsDriven: json['kms_driven'],
      registrationCity: json['reg_city'],
    );
  }
}
