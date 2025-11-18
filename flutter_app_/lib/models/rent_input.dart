/// Model class representing the input data for rent prediction
class RentInput {
  final double bathrooms;
  final double bedrooms;
  final double squareFeet;
  final double latitude;
  final double longitude;
  final String category;
  final String condition;
  final String isFurnished;
  final String parkingSpace;
  final String amenities;  // NEW: Required by backend
  final String region;     // NEW: Required by backend
  final String locality;   // NEW: Required by backend

  RentInput({
    required this.bathrooms,
    required this.bedrooms,
    required this.squareFeet,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.condition,
    required this.isFurnished,
    required this.parkingSpace,
    required this.amenities,
    required this.region,
    required this.locality,
  });

  /// Convert the model to JSON format for API request
  Map<String, dynamic> toJson() {
    return {
      'bathrooms': bathrooms,
      'bedrooms': bedrooms,
      'floor_area': squareFeet,
      'lat': latitude,
      'lng': longitude,
      'category': category,
      'condition': condition,
      'is_furnished': isFurnished,
      'parking_space': parkingSpace,
      'amenities': amenities,
      'region': region,
      'locality': locality,
    };
  }
}

/// Model class for the API response
class RentPredictionResponse {
  final double? predictedRent;
  final String? error;

  RentPredictionResponse({
    this.predictedRent,
    this.error,
  });

  factory RentPredictionResponse.fromJson(Map<String, dynamic> json) {
    return RentPredictionResponse(
      predictedRent: json['predicted_rent'] != null 
          ? (json['predicted_rent'] as num).toDouble() 
          : null,
      error: json['error'],
    );
  }
}