// lib/modules/auth/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:zidasp_app/core/di.dart';
import 'package:zidasp_app/widgets/shared/custom_card.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
 late final controller = inject<ProfileController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Watch(
        (context) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProfileHeader(),
                const SizedBox(height: 16),
                _buildStatsCard(), // Card com dados extras do DTO
                const SizedBox(height: 16),
                _buildCompaniesCard(),
                const SizedBox(height: 16),
                _buildSettingsCard(),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildProfileHeader() {
    return CustomCard(
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.shrimpAlert.withOpacity(0.1),
            child: Watch(
              (context) => Text(
                controller.userInitials.value,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.shrimpAlert,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Nome
          Watch(
            (context) => Text(
              controller.userName.value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Email
          Watch(
            (context) => Text(
              controller.userEmail.value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ),
          
          // Role badge (vem do DTO)
          Watch(
            (context) => Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: controller.getRoleColor(controller.userRole.value).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                controller.userRole.value.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: controller.getRoleColor(controller.userRole.value),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatsCard() {
    return CustomCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Total viveiros (do DTO)
          Watch(
            (context) => _buildStatItem(
              'Viveiros',
              '${controller.totalPonds.value}',
            ),
          ),
          
          // Total empresas (do DTO)
          Watch(
            (context) => _buildStatItem(
              'Empresas',
              '${controller.companiesCount.value}',
            ),
          ),
          
          // Data de cadastro (do DTO)
          Watch(
            (context) => _buildStatItem(
              'Desde',
              controller.joinDate.value?.year.toString() ?? '',
            ),
          ),
        ],
      ),
    );
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
  
  Widget _buildCompaniesCard() {
    return Watch(
      (context) {
        final companies = controller.companiesDTO.value;
        
        return CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Empresas Associadas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              ...companies.map((company) {
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
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: controller.getRoleColor(company.userRole).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        company.userRole.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: controller.getRoleColor(company.userRole),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildSettingsCard() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Configurações',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 8),
          
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Editar Perfil'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showEditDialog,
          ),
          
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Alterar Senha'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showPasswordDialog,
          ),
          
          const Divider(),
          
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.shrimpAlert),
            title: const Text(
              'Sair',
              style: TextStyle(color: AppColors.shrimpAlert),
            ),
            onTap: _showLogoutDialog,
          ),
        ],
      ),
    );
  }
  
  void _showEditDialog() {
    final nameController = TextEditingController(text: controller.user.value?.name);
    final emailController = TextEditingController(text: controller.user.value?.email);
    final documentController = TextEditingController(text: controller.user.value?.document);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Perfil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: documentController,
              decoration: const InputDecoration(labelText: 'Documento'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await controller.updateProfile(
                name: nameController.text,
                email: emailController.text,
                document: documentController.text,
              );
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
  
  void _showPasswordDialog() {
    // Implementar...
  }
  
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await controller.logout();
              // Navegar para login
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