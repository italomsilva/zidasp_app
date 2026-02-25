// lib/modules/auth/controllers/profile_controller.dart
import 'dart:ui';

import 'package:signals/signals.dart';
import '../repositories/user_repository.dart';
import '../dtos/user_dto.dart';
import '../dtos/company_dto.dart';

class ProfileController {
  final UserRepository _repository;
  
  // Signals com DTOs (dados completos)
  final userDTO = signal<UserDTO?>(null);
  final companiesDTO = signal<List<CompanyDTO>>([]);
  
  // Computed que expõe apenas o Model (simples)
  late final user = computed(() => userDTO.value?.toModel());
  
  // Outros computed para dados extras do DTO
  late final userRole = computed(() => userDTO.value?.role ?? '');
  late final totalPonds = computed(() => userDTO.value?.totalPonds ?? 0);
  late final companiesCount = computed(() => userDTO.value?.companiesCount ?? 0);
  late final joinDate = computed(() => userDTO.value?.joinDate);
  late final token = computed(() => userDTO.value?.token ?? '');
  
  // Signals de UI
  late final userInitials = computed(() => user.value?.initials ?? '');
  late final userName = computed(() => user.value?.name ?? '');
  late final userEmail = computed(() => user.value?.email ?? '');
  late final userDocument = computed(() => user.value?.document ?? '');
  
  final isLoading = signal<bool>(false);
  final isSaving = signal<bool>(false);
  final error = signal<String?>(null);
  
  ProfileController(this._repository) {
    loadProfileData();
  }
  
  Future<void> loadProfileData() async {
    isLoading.value = true;
    error.value = null;
    
    try {
      // Carrega dados em paralelo
      final results = await Future.wait([
        _repository.getCurrentUser(),
        _repository.getUserCompanies(),
      ]);
      
      userDTO.value = results[0] as UserDTO;
      companiesDTO.value = results[1] as List<CompanyDTO>;
      
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<bool> updateProfile({
    required String name,
    required String email,
    required String document,
  }) async {
    isSaving.value = true;
    error.value = null;
    
    try {
      final updatedDTO = await _repository.updateProfile(
        name: name,
        email: email,
        document: document,
      );
      
      userDTO.value = updatedDTO;
      return true;
      
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isSaving.value = false;
    }
  }
  
  Future<void> logout() async {
    await _repository.logout();
    userDTO.value = null;
    companiesDTO.value = [];
  }
  
  // Helper para cor da role
  Color getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return const Color(0xFFFF6B6B);
      case 'admin':
        return const Color(0xFF3498DB);
      case 'employee':
        return const Color(0xFF27AE60);
      default:
        return const Color(0xFFF1C40F);
    }
  }
}