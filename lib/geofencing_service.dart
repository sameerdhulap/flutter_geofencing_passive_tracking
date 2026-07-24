import 'package:flutter/material.dart';
import 'package:geofencing_flutter_plugin/geofencing_flutter_plugin.dart';

/// Thin wrapper around the Woosmap Geofencing Flutter plugin.
///
/// The Dart layer is only responsible for initializing the plugin and starting
/// the `passiveTracking` profile. Region events (enter/exit) are captured and
/// forwarded to the back-office natively:
///   - iOS:     ios/Runner/GeofencingEventsReceiver.swift
///   - Android: android/.../GeofencingEventsReceiver.kt
class GeofencingService {
  final GeofencingFlutterPlugin _geofencing = GeofencingFlutterPlugin();

  /// Initialize the plugin and start passive tracking.
  ///
  /// Call this only AFTER the user has granted location permission
  /// (WhenInUse, then Always for background/passive tracking).
  Future<void> initAndStart() async {
    // 1. Initialize the plugin.
    //    protectedRegionSlot is optional: on iOS it reserves up to 3 of the
    //    20 CLRegion slots for a third-party plugin. Set to 0 if not needed.
    try {
      final WoosmapGeofencingOptions options =
          WoosmapGeofencingOptions(protectedRegionSlot: 0);
      final String? initResult = await _geofencing.initialize(options);
      debugPrint('Woosmap init: $initResult');
    } catch (e) {
      debugPrint('Woosmap init error: $e');
      return;
    }

    // 2. Start passive tracking.
    //    Accepted profiles: liveTracking, passiveTracking,
    //    optimalPassiveTracking, visitsTracking, beaconTracking.
    try {
      final String? result = await _geofencing.startTracking('passiveTracking');
      debugPrint('startTracking(passiveTracking): $result');
    } catch (e) {
      debugPrint('startTracking error: $e');
    }
  }

  /// Stop tracking (e.g. when the user opts out).
  Future<void> stop() async {
    try {
      final String? result = await _geofencing.stopTracking();
      debugPrint('stopTracking: $result');
    } catch (e) {
      debugPrint('stopTracking error: $e');
    }
  }
}
