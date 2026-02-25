// lib/modules/tide/repositories/tide_repository.dart
import 'package:flutter/material.dart';

class TideRepository {
  // Dados mock das marés
  final List<Map<String, dynamic>> _mockTides = [
    {'time': '06:45', 'type': 'Alta', 'height': '2.5m'},
    {'time': '14:30', 'type': 'Baixa', 'height': '0.8m'},
    {'time': '19:45', 'type': 'Alta', 'height': '2.8m'},
    {'time': '02:15', 'type': 'Baixa', 'height': '0.5m'},
  ];
  
  final List<String> _weekDays = ['SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SÁB', 'DOM'];
  
  // Retorna as marés do dia
  Future<List<Map<String, dynamic>>> getTidesForDay(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockTides;
  }
  
  // Retorna a maré atual baseada no horário
  Map<String, dynamic> getCurrentTide() {
    final now = DateTime.now();
    final isHighTide = now.hour < 12;
    
    return {
      'type': isHighTide ? 'PREIA-MAR' : 'BAIXA-MAR',
      'height': isHighTide ? '2.8m' : '0.5m',
      'nextTide': isHighTide ? 'Baixa-mar: 14:30' : 'Preia-mar: 19:45',
      'isHigh': isHighTide,
    };
  }
  
  // Retorna a previsão semanal
  List<Map<String, dynamic>> getWeeklyForecast() {
    return _weekDays.asMap().entries.map((entry) {
      final index = entry.key;
      final day = entry.value;
      final isHighTide = index % 2 == 0;
      
      return {
        'day': day,
        'initial': day[0],
        'type': isHighTide ? 'Alta' : 'Baixa',
        'isHigh': isHighTide,
        'icon': isHighTide ? Icons.arrow_upward : Icons.arrow_downward,
      };
    }).toList();
  }
  
  // Verifica se um dia é hoje
  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }
}