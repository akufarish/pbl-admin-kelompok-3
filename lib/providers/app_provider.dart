// lib/providers/app_provider.dart
import 'package:flutter/foundation.dart';
import 'package:hit_api/models/api_models.dart';
import 'package:hit_api/services/api_service.dart';

class AppProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  bool isLoading = false;
  String? errorMsg;

  List<Mahasiswa> mahasiswaList = [];

  String? loggedInNama;
  bool get isLoggedIn => _api.isLoggedIn;

  // ============ AUTH (LOGIN & LOGOUT) ============\n  Future<bool> login(String email, String password) async {
  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMsg = null;
    notifyListeners();
    try {
      final res = await _api.loginKarlearn(email, password);
      if (res != null) {
        loggedInNama = res.nama;
        return true;
      }
      errorMsg = "Login gagal. Periksa email dan password.";
      return false;
    } catch (e) {
      errorMsg = "Terjadi kesalahan server.";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _api.clearToken();
    loggedInNama = null;
    mahasiswaList.clear();
    notifyListeners();
  }

  // ============ MAHASISWA ============\n  Future<void> fetchMahasiswa() async {
  Future<void> fetchMahasiswa() async {
    isLoading = true;
    notifyListeners();
    try {
      mahasiswaList = await _api.getMahasiswa();
    } catch (e) {
      debugPrint("Provider Error fetchMahasiswa: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
