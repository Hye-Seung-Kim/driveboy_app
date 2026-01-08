import 'package:flutter/material.dart';
import 'dart:async';
import '../services/esp32_service.dart';

class DrivingScreen extends StatefulWidget {
  final ESP32Service esp32Service;

  const DrivingScreen({super.key, required this.esp32Service});

  @override
  State<DrivingScreen> createState() => _DrivingScreenState();
}

class _DrivingScreenState extends State<DrivingScreen> {
  Timer? _timer;
  int _elapsedSeconds = 0;

  // Wellness tracking
  DateTime? _lastMeal;
  DateTime? _lastWater;
  DateTime? _lastStretch;

  // Fatigue level (0: happy, 1: sleepy, 2: tired, 3: danger)
  int _fatigueLevel = 0;

  @override
  void initState() {
    super.initState();
    _startDrivingTimer();
    widget.esp32Service.setHappy();
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.esp32Service.setHappy(); // ← 추가 추천
    super.dispose();
  }

  void _startDrivingTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
        _updateFatigueLevel();
      });
    });
  }

  void _updateFatigueLevel() {
    int minutes = _elapsedSeconds ~/ 60;

    if (minutes >= 3) {
      _setFatigue(3); // danger
    } else if (minutes >= 2) {
      _setFatigue(2); // tired
    } else if (minutes >= 1) {
      _setFatigue(1); // sleepy
    } else {
      _setFatigue(0); // 1분 미만일 땐 항상 happy
    }
  }

  void _setFatigue(int level) {
    if (_fatigueLevel != level) {
      setState(() => _fatigueLevel = level);

      switch (level) {
        case 0:
          widget.esp32Service.setHappy();
          break;
        case 1:
          widget.esp32Service.setSleepy();
          break;
        case 2:
          widget.esp32Service.setTired();
          break;
        case 3:
          widget.esp32Service.setDanger();
          break;
      }
    }
  }

  String _formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  }

  void _logMeal() {
    setState(() => _lastMeal = DateTime.now());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meal logged! 🍽️')),
    );
  }

  void _logWater() {
    setState(() => _lastWater = DateTime.now());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Water logged! 💧')),
    );
  }

  void _logStretch() {
    setState(() => _lastStretch = DateTime.now());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Stretch logged! 🧘')),
    );
  }

  void _findRestStops() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Search location...',
                            hintStyle: TextStyle(color: Colors.white30),
                            border: InputBorder.none,
                            icon: Icon(Icons.search, color: Colors.white30),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Rest stops list
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildRestStopCard(
                      name: 'Flying J Travel Center',
                      distance: '2 mi away',
                      duration: '5 min',
                      rating: 4.2,
                    ),
                    const SizedBox(height: 12),
                    _buildRestStopCard(
                      name: 'Service Plaza North',
                      distance: '5.1 mi away',
                      duration: '8 min',
                      rating: 3.8,
                    ),
                    const SizedBox(height: 12),
                    _buildRestStopCard(
                      name: 'Rest Area Mile 45',
                      distance: '8.7 mi away',
                      duration: '12 min',
                      rating: 4.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestStopCard({
    required String name,
    required String distance,
    required String duration,
    required double rating,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFF9800), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        color: Color(0xFFFF9800),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$distance · $duration',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4A90E2),
            ),
          ),
          const SizedBox(height: 16),

          // Amenities
          Row(
            children: [
              Expanded(
                  child: _buildAmenityChip(
                      Icons.local_parking, 'Parking', 'Available')),
              const SizedBox(width: 8),
              Expanded(
                  child:
                      _buildAmenityChip(Icons.restaurant, 'Food', "Denny's")),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                  child: _buildAmenityChip(
                      Icons.local_gas_station, 'Fuel', 'Diesel')),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildAmenityChip(Icons.wc, 'Restrooms', 'Clean')),
            ],
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90E2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Get Directions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityChip(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF4A90E2), size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white60,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driving Hours Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Driving Hours',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white60,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDuration(_elapsedSeconds),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Fatigue Alert
            if (_fatigueLevel >= 2) _buildFatigueAlert(),
            if (_fatigueLevel >= 2) const SizedBox(height: 20),

            // Wellness Tracker
            const Text(
              'Wellness Tracker',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            _buildWellnessItem(
              icon: Icons.restaurant,
              title: 'Meal Time',
              nextTime: _lastMeal,
              defaultTime: '12:00 PM',
              color: const Color(0xFF4A90E2),
              buttonText: 'Log Meal',
              onPressed: _logMeal,
            ),
            const SizedBox(height: 12),
            _buildWellnessItem(
              icon: Icons.water_drop,
              title: 'Hydration',
              nextTime: _lastWater,
              defaultTime: '1:00 PM',
              color: const Color(0xFF50C878),
              buttonText: 'Log Water',
              onPressed: _logWater,
            ),
            const SizedBox(height: 12),
            _buildWellnessItem(
              icon: Icons.accessibility_new,
              title: 'Stretch Break',
              nextTime: _lastStretch,
              defaultTime: '2:00 PM',
              color: const Color(0xFFD4A574),
              buttonText: 'Log Stretch',
              onPressed: _logStretch,
            ),

            const SizedBox(height: 24),

            // Find Rest Stops Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _findRestStops,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Find Rest Stops',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFatigueAlert() {
    String alertText =
        _fatigueLevel >= 3 ? 'Time to rest!' : 'Take a break soon';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF8B4513).withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD2691E),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.warning_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fatigue Alert',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  alertText,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWellnessItem({
    required IconData icon,
    required String title,
    required DateTime? nextTime,
    required String defaultTime,
    required Color color,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    String displayTime;
    if (nextTime != null) {
      final diff = DateTime.now().difference(nextTime);
      if (diff.inMinutes < 60) {
        displayTime = '${diff.inMinutes}m ago';
      } else {
        displayTime = '${diff.inHours}h ago';
      }
    } else {
      displayTime = 'Next: $defaultTime';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  displayTime,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
