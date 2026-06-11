import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:majadigi_superapp_frontend/models/auth_model.dart';
import 'package:majadigi_superapp_frontend/services/api/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  // Check login status on app startup
  Future<bool> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final userJsonString = prefs.getString('user_profile');

      if (token != null && token.isNotEmpty && userJsonString != null) {
        final Map<String, dynamic> userMap = jsonDecode(userJsonString) as Map<String, dynamic>;
        _user = User.fromJson(userMap);
        _isAuthenticated = true;
        notifyListeners();
        
        // Fetch fresh profile in background
        fetchUserProfile();
        return true;
      }
    } catch (e) {
      debugPrint('Error checking login status: $e');
    }
    _isAuthenticated = false;
    notifyListeners();
    return false;
  }

  // Fetch updated profile from server
  Future<void> fetchUserProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedUser = await _authRepository.getProfile();
      _user = updatedUser;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_profile', jsonEncode(updatedUser.toJson()));
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint('Error fetching user profile: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Handle Login Action
  Future<bool> login({
    required String nik,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authRepository.login(nik: nik, password: password);
      
      if (response.status == 'success' && response.data != null) {
        final authData = response.data!;
        
        // Save tokens & profile to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', authData.accessToken);
        await prefs.setString('refresh_token', authData.refreshToken);
        await prefs.setString('user_profile', jsonEncode(authData.user.toJson()));
        
        _user = authData.user;
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        
        // Fetch full profile info in background
        fetchUserProfile();
        return true;
      } else {
        _errorMessage = response.message;
        _isAuthenticated = false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isAuthenticated = false;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Handle Logout Action
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Clear storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      await prefs.remove('user_profile');
      await prefs.remove('logged_in_nik');
    } catch (e) {
      debugPrint('Error clearing credentials: $e');
    }

    _user = null;
    _isAuthenticated = false;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> register({
    required String nik,
    required String password,
    required String nama,
    required String noHp,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authRepository.register(
        nik: nik,
        password: password,
        nama: nama,
        noHp: noHp,
      );
      
      if (result['status'] != 'error' && result['status'] != 'fail') {
        _errorMessage = result['message'] ?? 'Registrasi berhasil!';
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'] ?? 'Gagal melakukan registrasi.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
