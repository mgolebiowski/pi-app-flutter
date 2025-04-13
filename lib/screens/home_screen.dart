import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/stop_data.dart';
import '../models/tram.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  StopData _stopData = StopData.empty();
  DateTime _currentDateTime = DateTime.now();
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _dataRefreshTimer;
  Timer? _timeUpdateTimer;

  @override
  void initState() {
    super.initState();
    // Fetch data initially
    _fetchStopData();
    
    // Set up a timer to refresh data every 10 seconds
    _dataRefreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _fetchStopData();
    });
    
    // Set up a timer to update the time every second
    _timeUpdateTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _currentDateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _dataRefreshTimer?.cancel();
    _timeUpdateTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchStopData() async {
    try {
      setState(() {
        _errorMessage = null;
      });
      
      final stopData = await _apiService.fetchStopData();
      setState(() {
        _stopData = stopData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data. Please check your connection.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left - Czyzyny text
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                'Czyżyny',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            
            // Center - Current time
            Text(
              DateFormat('HH:mm:ss').format(_currentDateTime),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            // Right - Date and weather
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('dd.MM.yyyy').format(_currentDateTime),
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      '${_stopData.weather.temperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Image.network(
                  _stopData.weather.iconUrl,
                  width: 30,
                  height: 30,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.cloud_queue, size: 30);
                  },
                ),
              ],
            ),
          ],
        ),
        centerTitle: false,
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.blue[700],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchStopData,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchStopData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    
    return Column(
      children: [
        Expanded(child: _buildTramList()),
      ],
    );
  }

  Widget _buildTramList() {
    if (_stopData.trams.isEmpty) {
      return const Center(
        child: Text('No trams scheduled at the moment'),
      );
    }

    // Use a compact ListView to show more trams vertically
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      itemCount: _stopData.trams.length,
      // Reduce item spacing to fit more items
      itemExtent: 60, // Fixed height for each item to fit more trams
      itemBuilder: (context, index) {
        final tram = _stopData.trams[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: _buildTramCard(tram),
        );
      },
    );
  }

  Widget _buildTramCard(Tram tram) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Row(
          children: [
            // Line number circle - made smaller
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue[700],
              ),
              alignment: Alignment.center,
              child: Text(
                tram.line,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Direction and city center indicator
            Expanded(
              child: Row(
                children: [
                  if (tram.isTripToCityCenter) 
                    const Padding(
                      padding: EdgeInsets.only(right: 4.0),
                      child: Icon(Icons.location_city, color: Colors.blue, size: 16),
                    ),
                  Expanded(
                    child: Text(
                      tram.direction,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            // ETA in minutes
            Text(
              tram.etaString,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: tram.isImminentArrival ? Colors.red : Colors.green[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}