import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:zidasp_app/core/sesssion/models/company_session.dart';
import 'package:zidasp_app/core/theme/app_theme.dart';

class CompanyDropdown extends StatefulWidget {
  const CompanyDropdown({super.key, required this.companies, required this.selectedCompanyId, required this.selectCompany});

  final Signal<List<CompanySession?>> companies;
  final Signal<String?> selectedCompanyId;
  final Function selectCompany;

  @override
  State<CompanyDropdown> createState() => _CompanyDropdownState();
}

class _CompanyDropdownState extends State<CompanyDropdown> {
  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.business, color: AppColors.shrimpAlert, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButton<String>(
                value: widget.selectedCompanyId.value,
                hint: Text(
                  'Selecionar empresa',
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                icon: Icon(Icons.arrow_drop_down, color: AppColors.shrimpAlert),
                isExpanded: true,
                underline: const SizedBox(),
                dropdownColor: Theme.of(context).cardColor,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                items: widget.companies.value.map((company) {
                  return DropdownMenuItem<String>(
                    value: company?.id,
                    child: Text(company?.name ?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    widget.selectCompany(value);
                  }
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
