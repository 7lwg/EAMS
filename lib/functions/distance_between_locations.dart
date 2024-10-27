import 'dart:math';

double haversine(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371.0; // Earth's radius in kilometers

  // Convert degrees to radians
  double dLat = _degToRad(lat2 - lat1);
  double dLon = _degToRad(lon2 - lon1);

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_degToRad(lat1)) *
          cos(_degToRad(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  // Distance in kilometers
  double distance = earthRadius * c;

  return distance;
}

double _degToRad(double degree) {
  return degree * pi / 180;
}
