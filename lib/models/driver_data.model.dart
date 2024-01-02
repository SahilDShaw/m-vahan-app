class DriverData {
  String dlNo;
  String name;
  String address;
  DateTime dob;

  DriverData({
    required this.dlNo,
    required this.name,
    required this.address,
    required this.dob,
  });

  factory DriverData.fromJson(Map<String, dynamic> json) {
    return DriverData(
      dlNo: json['dl_no'],
      name: json['name'],
      address: json['address'],
      dob: DateTime.parse(json['dob']),
    );
  }
}
