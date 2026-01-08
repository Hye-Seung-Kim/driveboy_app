import 'dart:async';
import 'package:http/http.dart' as http;

class ESP32Service {
  // ESP32의 IP 주소로 변경
  static const String baseUrl = 'http://10.0.1.74'; // ← 시리얼 모니터에서 확인한 IP

  // Singleton pattern
  static final ESP32Service _instance = ESP32Service._internal();
  factory ESP32Service() => _instance;
  ESP32Service._internal();

  // ===== 연결 테스트 =====
  Future<bool> ping() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/ping'),
          )
          .timeout(const Duration(seconds: 3));

      return response.statusCode == 200 && response.body == 'pong';
    } catch (e) {
      print('[ESP32] Ping failed: $e');
      return false;
    }
  }

  // ===== 표정 변경 =====
  // s: "happy" | "sleepy" | "tired" | "danger"
  Future<bool> setFace(String face) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/face?s=$face'),
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        print('[ESP32] Face changed to: $face');
        return true;
      } else {
        print('[ESP32] Face change failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('[ESP32] Face change error: $e');
      return false;
    }
  }

  // ===== 편의 메서드 =====
  Future<bool> setHappy() => setFace('happy');
  Future<bool> setSleepy() => setFace('sleepy');
  Future<bool> setTired() => setFace('tired');
  Future<bool> setDanger() => setFace('danger');

  // ===== 애니메이션 표정 =====
  Future<bool> setBreatheIn() => setFace('breathe_in');
  Future<bool> setBreatheOut() => setFace('breathe_out');
  Future<bool> setExercise() => setFace('exercise');
  Future<bool> setLaugh() => setFace('laugh');
  Future<bool> setFocus() => setFace('focus');

  // ===== 호흡 애니메이션 제어 =====
  Future<bool> startBreathing() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/breathe?action=start'),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        print('[ESP32] Breathing animation started');
        return true;
      } else {
        print('[ESP32] Breathing start failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('[ESP32] Breathing start error: $e');
      return false;
    }
  }

  Future<bool> stopBreathing() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/breathe?action=stop'),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        print('[ESP32] Breathing animation stopped');
        return true;
      } else {
        print('[ESP32] Breathing stop failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('[ESP32] Breathing stop error: $e');
      return false;
    }
  }
}
