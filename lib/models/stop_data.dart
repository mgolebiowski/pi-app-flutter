import 'tram.dart';
import 'weather.dart';

class StopData {
  final List<Tram> trams;
  final Weather weather;
  
  StopData({
    required this.trams,
    required this.weather,
  });
  
  factory StopData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> tramList = json['trams'] ?? [];
    final List<Tram> trams = tramList.map((tramJson) => Tram.fromJson(tramJson)).toList();
    
    final Weather weather = Weather.fromJson(json['weather'] ?? {});
    
    return StopData(
      trams: trams,
      weather: weather,
    );
  }
  
  factory StopData.empty() {
    return StopData(
      trams: [],
      weather: Weather(temperature: 0, iconCode: '01d'),
    );
  }
}