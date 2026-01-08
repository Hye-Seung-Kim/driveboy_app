import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  // UUIDs - must match ESP32 code
  static const String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  static const String CHAR_RX_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  static const String CHAR_TX_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a9";

  // 테스트 모드
  bool testMode = true; // true면 실제 BLE 없이 시뮬레이션

  BluetoothDevice? _device;
  BluetoothCharacteristic? _rxCharacteristic;
  BluetoothCharacteristic? _txCharacteristic;

  final _connectionController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionController.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<void> scanAndConnect() async {
    try {
      // Check if Bluetooth is on
      if (await FlutterBluePlus.adapterState.first !=
          BluetoothAdapterState.on) {
        print('[BLE] Bluetooth is off');
        return;
      }

      print('[BLE] Starting scan...');

      // Start scanning
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

      // Listen for scan results
      FlutterBluePlus.scanResults.listen((results) async {
        for (var result in results) {
          // Look for "Driveboy" device
          if (result.device.platformName.contains('Driveboy') ||
              result.device.platformName.contains('ESP32')) {
            print('[BLE] Found device: ${result.device.platformName}');
            await FlutterBluePlus.stopScan();
            await _connectToDevice(result.device);
            return;
          }
        }
      });

      // Wait for scan to complete
      await Future.delayed(const Duration(seconds: 10));
      await FlutterBluePlus.stopScan();
    } catch (e) {
      print('[BLE] Scan error: $e');
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      print('[BLE] Connecting to ${device.platformName}...');

      await device.connect(timeout: const Duration(seconds: 10));
      _device = device;

      print('[BLE] Connected! Discovering services...');

      // Discover services
      List<BluetoothService> services = await device.discoverServices();

      for (var service in services) {
        if (service.uuid.toString().toLowerCase() ==
            SERVICE_UUID.toLowerCase()) {
          print('[BLE] Found Driveboy service');

          for (var char in service.characteristics) {
            String charUuid = char.uuid.toString().toLowerCase();

            if (charUuid == CHAR_RX_UUID.toLowerCase()) {
              _rxCharacteristic = char;
              print('[BLE] Found RX characteristic');
            }
            if (charUuid == CHAR_TX_UUID.toLowerCase()) {
              _txCharacteristic = char;
              print('[BLE] Found TX characteristic');

              // Enable notifications
              await char.setNotifyValue(true);
              char.onValueReceived.listen((value) {
                String received = String.fromCharCodes(value);
                print('[BLE] Received: $received');
              });
            }
          }
        }
      }

      _isConnected = true;
      _connectionController.add(true);
      print('[BLE] Setup complete!');

      // Listen for disconnection
      device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected) {
          _isConnected = false;
          _connectionController.add(false);
          print('[BLE] Disconnected');
        }
      });
    } catch (e) {
      print('[BLE] Connection error: $e');
      _isConnected = false;
      _connectionController.add(false);
    }
  }

  Future<void> sendCommand(String command) async {
    // ⭐ 테스트 모드: 실제 전송 없이 로그만 출력
    if (testMode) {
      print('[BLE-TEST] Would send: $command');
      _simulateResponse(command);
      return;
    }

    if (_rxCharacteristic == null) {
      print('[BLE] Not connected - cannot send: $command');
      return;
    }

    try {
      await _rxCharacteristic!.write(command.codeUnits, withoutResponse: false);
      print('[BLE] Sent: $command');
    } catch (e) {
      print('[BLE] Send error: $e');
    }
  }

  // ⭐ 테스트 모드용 시뮬레이션 응답
  void _simulateResponse(String command) {
    if (command.startsWith("M:")) {
      String mode = command == "M:0" ? "DRIVING" : "REST";
      print('[BLE-TEST] ESP32 would switch to $mode mode');
    } else if (command.startsWith("F:")) {
      List<String> levels = ["FRESH 😊", "FOCUSED 😐", "TIRED 😴", "DANGER 💤"];
      int level = int.tryParse(command.substring(2)) ?? 0;
      print('[BLE-TEST] ESP32 would show fatigue: ${levels[level]}');
    } else if (command.startsWith("R:")) {
      List<String> emotions = [
        "HAPPY 😊",
        "CALM 😌",
        "LONELY 🥺",
        "COMFORT 🥰"
      ];
      int emo = int.tryParse(command.substring(2)) ?? 0;
      print('[BLE-TEST] ESP32 would show emotion: ${emotions[emo]}');
    }
  }

  Future<void> disconnect() async {
    await _device?.disconnect();
    _isConnected = false;
    _connectionController.add(false);
  }

  void dispose() {
    _connectionController.close();
    disconnect();
  }
}
