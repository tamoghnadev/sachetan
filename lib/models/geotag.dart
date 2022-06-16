import 'dart:ffi';

class GeoTag {
  String? cpid;
  String? latitude;
  String? longitude;


  toJson() {
    return {
      //'id': id.toString(),
      'comp_id': cpid.toString(),
      'lat': latitude.toString(),
      'lon': longitude.toString(),

    };
  }
}