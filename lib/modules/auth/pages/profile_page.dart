import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:zidasp_app/core/di.dart';
import 'package:zidasp_app/core/enums/user_role_enum.dart';
import 'package:zidasp_app/modules/admin/pages/admin_panel_page.dart';
import 'package:zidasp_app/widgets/shared/custom_card.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final controller = inject<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Watch((context) {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.shrimpAlert),
          );
        }

        return CustomScrollView(
          slivers: [
            _buildSliverHeader(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildStatsCard(),
                    const SizedBox(height: 24),
                    _buildCompaniesSection(),
                    const SizedBox(height: 24),
                    _buildSettingsSection(),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSliverHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              _buildAvatar(),
              const SizedBox(height: 16),
              _buildUserNameAndEmail(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.shrimpAlert.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.shrimpAlert.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 45,
        backgroundColor: AppColors.shrimpAlert.withValues(alpha: 0.05),
        child: Watch(
          (context) => Text(
            controller.userInitials.value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.shrimpAlert,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserNameAndEmail(BuildContext context) {
    return Column(
      children: [
        Watch(
          (context) => Text(
            controller.userName.value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        Watch(
          (context) => Text(
            controller.userEmail.value,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Watch(
              (context) => _buildStatItem(
                Icons.waves,
                'Viveiros',
                '${controller.totalPonds.value}',
              ),
            ),
            _buildVerticalDivider(),
            Watch(
              (context) => _buildStatItem(
                Icons.business,
                'Empresas',
                '${controller.totalCompanies.value}',
              ),
            ),
            _buildVerticalDivider(),
            Watch(
              (context) => _buildStatItem(
                Icons.calendar_today,
                'Desde',
                controller.joinDate.value?.year.toString() ?? '',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.withValues(alpha: 0.2),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.shrimpAlert),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildCompaniesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'MINHAS EMPRESAS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.grey,
            ),
          ),
        ),
        Watch((context) {
          final companies = controller.companiesDTO.value;
          if (companies.isEmpty) {
            return const Text('Nenhuma empresa encontrada');
          }

          return Column(
            children: companies
                .map((company) => _buildCompanyItem(company))
                .toList(),
          );
        }),
      ],
    );
  }

  Widget _buildCompanyItem(dynamic company) {
    final isAdmin = company.userRole == UserRoleEnum.admin;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.shrimpAlert.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.business, color: AppColors.shrimpAlert),
          ),
          title: Text(
            company.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${company.totalPonds} viveiros • ${company.activePonds} ativos',
            style: const TextStyle(fontSize: 12),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRoleBadge(company.userRole),
              if (isAdmin) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: AppColors.shrimpAlert,
                    size: 22,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminPanelPage(companyId: company.id),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleBadge(UserRoleEnum role) {
    final color = controller.getRoleColor(role);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        role.value.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'CONFIGURAÇÕES DA CONTA',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.grey,
            ),
          ),
        ),
        CustomCard(
          child: Column(
            children: [
              _buildSettingsTile(
                Icons.person_outline,
                'Editar Perfil',
                _showEditDialog,
              ),
              const Divider(height: 1),
              _buildSettingsTile(
                Icons.lock_outline,
                'Alterar Senha',
                _showPasswordDialog,
              ),
              const Divider(height: 1),
              _buildSettingsTile(
                Icons.logout,
                'Sair',
                _showLogoutDialog,
                isDestructive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppColors.shrimpAlert : null;
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: isDestructive ? FontWeight.bold : null,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  /* --- Diálogos (Sem alterações estruturais, apenas manter funcionalidade) --- */

  void _showEditDialog() {
    final nameController = TextEditingController(
      text: controller.user.value?.name,
    );
    final emailController = TextEditingController(
      text: controller.user.value?.email,
    );
    final documentController = TextEditingController(
      text: controller.user.value?.document,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Perfil'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.shrimpAlert,
            ),
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

  void _showPasswordDialog() {}

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Text('Tem certeza que deseja sair da conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await controller.logout();
            },
            child: const Text(
              'Sair',
              style: TextStyle(
                color: AppColors.shrimpAlert,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
