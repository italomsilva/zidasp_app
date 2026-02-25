// lib/modules/tide/screens/tide_screen.dart
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:zidasp_app/widgets/shared/custom_card.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/tide_controller.dart';
import '../repositories/tide_repository.dart';

class TidePage extends StatefulWidget {
  const TidePage({Key? key}) : super(key: key);
  
  @override
  State<TidePage> createState() => _TidePageState();
}

class _TidePageState extends State<TidePage> {
  // Controller com repository
  late final controller = TideController(TideRepository());
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Seletor de data
        _buildDateSelector(),
        
        Expanded(
          child: Watch(
            (context) {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (controller.error.value != null) {
                return Center(
                  child: Text('Erro: ${controller.error.value}'),
                );
              }
              
              return ListView(
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
              );
            },
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
            onPressed: controller.goToPreviousDay,
          ),
          
          Watch(
            (context) {
              return GestureDetector(
                onTap: () => controller.selectDateFromPicker(context),
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
                        controller.formattedDate.value,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: controller.goToNextDay,
          ),
        ],
      ),
    );
  }
  
  Widget _buildCurrentTideCard() {
    final tide = controller.currentTide;
    
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
                  color: tide['isHigh'] 
                      ? AppColors.neutralBlue.withOpacity(0.1)
                      : AppColors.shrimpAlert.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tide['type'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: tide['isHigh'] ? AppColors.neutralBlue : AppColors.shrimpAlert,
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
                  alignment: Alignment(0, tide['isHigh'] ? -0.3 : 0.3),
                  child: Container(
                    width: double.infinity,
                    height: 4,
                    color: tide['isHigh'] ? AppColors.neutralBlue : AppColors.shrimpAlert,
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
                    tide['nextTide'],
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
                    tide['height'],
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
    return Watch(
      (context) {
        final tides = controller.dailyTides.value;
        
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
      },
    );
  }
  
  Widget _buildWeeklyTideCard() {
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
            children: controller.weeklyForecast.map((forecast) {
              final isToday = forecast['day'] == _getTodayWeekDay();
              
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
                        forecast['initial'],
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
                    forecast['icon'],
                    size: 16,
                    color: forecast['isHigh'] 
                        ? AppColors.neutralBlue 
                        : AppColors.shrimpAlert,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    forecast['type'],
                    style: TextStyle(
                      fontSize: 10,
                      color: forecast['isHigh'] 
                          ? AppColors.neutralBlue 
                          : AppColors.shrimpAlert,
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
  
  String _getTodayWeekDay() {
    final weekDays = ['SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SÁB', 'DOM'];
    return weekDays[DateTime.now().weekday - 1];
  }
}