class PDF {
  String name;
  String base64String;
  String size;

  PDF({
    required this.name,
    required this.base64String,
    required this.size,
  });

  toJSON() {
    return {
      "Name": name,
      "base64String": base64String,
      "size": size,
    };
  }
}
