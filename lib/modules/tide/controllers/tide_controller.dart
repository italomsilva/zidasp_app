// lib/modules/tide/controllers/tide_controller.dart
import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import '../repositories/tide_repository.dart';

class TideController {
  final TideRepository _repository;
  
  // Signals
  final selectedDate = signal<DateTime>(DateTime.now());
  final dailyTides = signal<List<Map<String, dynamic>>>([]);
  final isLoading = signal<bool>(false);
  final error = signal<String?>(null);
  
  // Computed
  late final formattedDate = computed(() {
    return '${selectedDate.value.day.toString().padLeft(2, '0')}/'
           '${selectedDate.value.month.toString().padLeft(2, '0')}/'
           '${selectedDate.value.year}';
  });
  
  late final isToday = computed(() {
    final now = DateTime.now();
    final date = selectedDate.value;
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  });
  
  // Dados que não precisam ser signals (são estáticos)
  late final currentTide = _repository.getCurrentTide();
  late final weeklyForecast = _repository.getWeeklyForecast();
  
  TideController(this._repository) {
    _loadTidesForDate(selectedDate.value);
  }
  
  Future<void> _loadTidesForDate(DateTime date) async {
    isLoading.value = true;
    error.value = null;
    
    try {
      final tides = await _repository.getTidesForDay(date);
      dailyTides.value = tides;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  void selectDate(DateTime date) {
    selectedDate.value = date;
    _loadTidesForDate(date);
  }
  
  void goToPreviousDay() {
    selectDate(selectedDate.value.subtract(const Duration(days: 1)));
  }
  
  void goToNextDay() {
    selectDate(selectedDate.value.add(const Duration(days: 1)));
  }
  
  Future<void> selectDateFromPicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      selectDate(date);
    }
  }
}