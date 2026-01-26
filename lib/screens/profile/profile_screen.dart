// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zidasp_app/models/user_model.dart';
import 'package:zidasp_app/providers/company_provider.dart';
import 'package:zidasp_app/theme/app_theme.dart';
import 'package:zidasp_app/widgets/shared/custom_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);
    final user = companyProvider.currentUser;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Informações pessoais
          _buildUserInfoCard(context, user),
          
          const SizedBox(height: 16),
          
          // Empresas associadas
          _buildCompaniesCard(context, companyProvider),
          
          const SizedBox(height: 16),
          
          // Configurações
          _buildSettingsCard(context),
        ],
      ),
    );
  }
  
  Widget _buildUserInfoCard(BuildContext context, User user) {
    return CustomCard(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.shrimpAlert.withOpacity(0.1),
            child: Text(
              user.initials,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.shrimpAlert,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            user.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 4),
          
          Text(
            user.email,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _getRoleColor(user.role).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user.role.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getRoleColor(user.role),
                fontSize: 12,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Viveiros', '${user.totalPonds}'),
              _buildStatItem('Empresas', '${user.companiesCount}'),
              _buildStatItem('Desde', user.joinDate.year.toString()),
            ],
          ),
        ],
      ),
    );
  }
  
  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return AppColors.shrimpAlert;
      case 'admin':
        return AppColors.neutralBlue;
      case 'employee':
        return AppColors.healthGreen;
      default:
        return AppColors.neutralYellow;
    }
  }
  
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
  
  Widget _buildCompaniesCard(BuildContext context, CompanyProvider provider) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Empresas Associadas',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // Adicionar nova empresa
                },
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          ...provider.userCompanies.map((company) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.shrimpAlert.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.business,
                    color: AppColors.shrimpAlert,
                    size: 20,
                  ),
                ),
                title: Text(company.name),
                subtitle: Text(
                  '${company.totalPonds} viveiros • ${company.activePonds} ativos',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getRoleColor(company.userRole).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    company.userRole.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getRoleColor(company.userRole),
                    ),
                  ),
                ),
                onTap: () {
                  // Ver detalhes da empresa
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
  
  Widget _buildSettingsCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configurações',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 12),
          
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificações'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Privacidade e Segurança'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Ajuda e Suporte'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.shrimpAlert),
            title: const Text(
              'Sair',
              style: TextStyle(color: AppColors.shrimpAlert),
            ),
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }
  
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // Implementar logout
              Navigator.pop(context);
            },
            child: const Text(
              'Sair',
              style: TextStyle(color: AppColors.shrimpAlert),
            ),
          ),
        ],
      ),
    );
  }
}