import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'geofencing_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Woosmap Geofencing REST Sample',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GeofencingService _service = GeofencingService();
  String _status = 'Idle';

  /// Request location permission before starting tracking.
  ///
  /// passiveTracking runs in the background, so you ultimately need
  /// "Always" (locationAlways). iOS requires requesting WhenInUse first,
  /// then upgrading to Always.
  Future<bool> _ensureLocationPermission() async {
    var status = await Permission.locationWhenInUse.request();
    if (!status.isGranted) return false;

    var always = await Permission.locationAlways.request();
    return always.isGranted;
  }

  Future<void> _start() async {
    setState(() => _status = 'Requesting permission...');
    final granted = await _ensureLocationPermission();
    if (!granted) {
      setState(() => _status = 'Location permission denied');
      return;
    }
    setState(() => _status = 'Starting passiveTracking...');
    await _service.initAndStart();
    setState(() => _status = 'passiveTracking started');
  }

  Future<void> _stop() async {
    await _service.stop();
    setState(() => _status = 'Tracking stopped');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Woosmap Geofencing REST Sample')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Status: $_status', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _start,
              child: const Text('Start passive tracking'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _stop,
              child: const Text('Stop tracking'),
            ),
          ],
        ),
      ),
    );
  }
}
