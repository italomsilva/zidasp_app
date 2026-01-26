// lib/screens/tide/tide_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zidasp_app/theme/app_theme.dart';
import 'package:zidasp_app/widgets/shared/custom_card.dart';

class TideScreen extends StatefulWidget {
  const TideScreen({Key? key}) : super(key: key);
  
  @override
  _TideScreenState createState() => _TideScreenState();
}

class _TideScreenState extends State<TideScreen> {
  DateTime _selectedDate = DateTime.now();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Seletor de data
        _buildDateSelector(),
        
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Status atual da maré
              _buildCurrentTideCard(),
              
              const SizedBox(height: 16),
              
              // Próximas marés do dia
              _buildTideScheduleCard(),
              
              const SizedBox(height: 16),
              
              // Calendário semanal
              _buildWeeklyTideCard(),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildDateSelector() {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
            },
          ),
          
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('dd/MM/yyyy').format(_selectedDate),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 1));
              });
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildCurrentTideCard() {
    final isHighTide = DateTime.now().hour < 12; // Exemplo
    final nextTide = isHighTide ? 'Baixa-mar: 14:30' : 'Preia-mar: 19:45';
    
    return CustomCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Maré Atual',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isHighTide 
                      ? AppColors.neutralBlue.withOpacity(0.1)
                      : AppColors.shrimpAlert.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isHighTide ? 'PREIA-MAR' : 'BAIXA-MAR',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isHighTide ? AppColors.neutralBlue : AppColors.shrimpAlert,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Visualização da maré
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  AppColors.neutralBlue.withOpacity(0.3),
                  AppColors.shrimpAlert.withOpacity(0.3),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Stack(
              children: [
                // Nível atual
                Align(
                  alignment: Alignment(0, isHighTide ? -0.3 : 0.3),
                  child: Container(
                    width: double.infinity,
                    height: 4,
                    color: isHighTide ? AppColors.neutralBlue : AppColors.shrimpAlert,
                  ),
                ),
                
                // Marcadores
                Positioned(
                  left: 20,
                  top: 10,
                  child: Text(
                    'Alta',
                    style: TextStyle(
                      color: AppColors.neutralBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 10,
                  child: Text(
                    'Baixa',
                    style: TextStyle(
                      color: AppColors.shrimpAlert,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Próxima Maré',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    nextTide,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Altura',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    isHighTide ? '2.8m' : '0.5m',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTideScheduleCard() {
    final tides = [
      {'time': '06:45', 'type': 'Alta', 'height': '2.5m'},
      {'time': '14:30', 'type': 'Baixa', 'height': '0.8m'},
      {'time': '19:45', 'type': 'Alta', 'height': '2.8m'},
      {'time': '02:15', 'type': 'Baixa', 'height': '0.5m'},
    ];
    
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Marés do Dia',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 12),
          
          ...tides.map((tide) {
            final isHigh = tide['type'] == 'Alta';
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isHigh ? AppColors.neutralBlue : AppColors.shrimpAlert,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tide['time']!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isHigh 
                          ? AppColors.neutralBlue.withOpacity(0.1)
                          : AppColors.shrimpAlert.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tide['type']!,
                      style: TextStyle(
                        color: isHigh ? AppColors.neutralBlue : AppColors.shrimpAlert,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    tide['height']!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
  
  Widget _buildWeeklyTideCard() {
    final weekDays = ['SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SÁB', 'DOM'];
    
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Previsão Semanal',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays.asMap().entries.map((entry) {
              final index = entry.key;
              final day = entry.value;
              final isToday = index == DateTime.now().weekday - 1;
              final isHighTide = index % 2 == 0;
              
              return Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isToday 
                          ? AppColors.shrimpAlert.withOpacity(0.1)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: isToday 
                          ? Border.all(color: AppColors.shrimpAlert, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        day[0], // Primeira letra
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isToday 
                              ? AppColors.shrimpAlert 
                              : Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    isHighTide ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 16,
                    color: isHighTide ? AppColors.neutralBlue : AppColors.shrimpAlert,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isHighTide ? 'Alta' : 'Baixa',
                    style: TextStyle(
                      fontSize: 10,
                      color: isHighTide ? AppColors.neutralBlue : AppColors.shrimpAlert,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}