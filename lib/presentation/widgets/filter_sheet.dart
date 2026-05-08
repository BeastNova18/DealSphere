import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/deals/deals_bloc.dart';
import '../../logic/deals/deals_event.dart';
import '../../logic/deals/deals_state.dart';
import '../theme/app_theme.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  String? _selectedIndustry;
  String? _selectedRisk;
  RangeValues _roiRange = const RangeValues(0, 50);

  final _industries = [
    'CleanTech',
    'FinTech',
    'HealthTech',
    'AgriTech',
    'Logistics',
  ];
  final _risks = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    final state = context.read<DealsBloc>().state;
    if (state is DealsLoaded) {
      _selectedIndustry = state.selectedIndustry;
      _selectedRisk = state.selectedRiskLevel;
      _roiRange = RangeValues(state.minROI ?? 0, state.maxROI ?? 50);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Deals',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndustry = null;
                    _selectedRisk = null;
                    _roiRange = const RangeValues(0, 50);
                  });
                  context.read<DealsBloc>().add(DealsFilterCleared());
                },
                child: const Text(
                  'Clear All',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Industry
          const Text(
            'Industry',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _industries.map((ind) {
                  final selected = _selectedIndustry == ind;
                  return GestureDetector(
                    onTap:
                        () => setState(
                          () => _selectedIndustry = selected ? null : ind,
                        ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              selected ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Text(
                        ind,
                        style: TextStyle(
                          color:
                              selected ? Colors.white : AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 20),

          // Risk Level
          const Text(
            'Risk Level',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Row(
            children:
                _risks.map((risk) {
                  final selected = _selectedRisk == risk;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap:
                          () => setState(
                            () => _selectedRisk = selected ? null : risk,
                          ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                selected ? AppColors.primary : AppColors.border,
                          ),
                        ),
                        child: Text(
                          risk,
                          style: TextStyle(
                            color:
                                selected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 20),

          // ROI Range
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ROI Range',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              Text(
                '${_roiRange.start.toInt()}% – ${_roiRange.end.toInt()}%',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          RangeSlider(
            values: _roiRange,
            min: 0,
            max: 50,
            divisions: 50,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.border,
            onChanged: (val) => setState(() => _roiRange = val),
          ),
          const SizedBox(height: 16),

          // Apply button
          ElevatedButton(
            onPressed: () {
              context.read<DealsBloc>().add(
                DealsFilterChanged(
                  industry: _selectedIndustry,
                  riskLevel: _selectedRisk,
                  minROI: _roiRange.start,
                  maxROI: _roiRange.end,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Apply Filters'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
