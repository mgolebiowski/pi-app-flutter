class Tram {
  final String tripId;
  final String line;
  final String direction;
  final String etaString;
  final bool isTripToCityCenter;
  
  Tram({
    required this.tripId,
    required this.line,
    required this.direction,
    required this.etaString,
    required this.isTripToCityCenter,
  });
  
  factory Tram.fromJson(Map<String, dynamic> json) {
    return Tram(
      tripId: json['tripId'] ?? '',
      line: json['line'] ?? '',
      direction: json['direction'] ?? '',
      etaString: json['eta'] ?? '',
      isTripToCityCenter: json['isTripToCityCenter'] ?? false,
    );
  }
  
  int get etaMinutes {
    // Extract the numerical value from the ETA string (e.g., "7 min" -> 7)
    final RegExp regex = RegExp(r'(\d+)');
    final match = regex.firstMatch(etaString);
    
    if (match != null) {
      return int.tryParse(match.group(1) ?? '0') ?? 0;
    }
    
    return 0;
  }
  
  bool get isImminentArrival => etaMinutes <= 5;
}