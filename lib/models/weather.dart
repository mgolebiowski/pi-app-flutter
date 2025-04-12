class Weather {
  final double temperature;
  final String iconCode;
  
  Weather({
    required this.temperature,
    required this.iconCode,
  });
  
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      iconCode: json['icon'] ?? '01d', // Default to clear sky if no icon code is provided
    );
  }
  
  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';
}