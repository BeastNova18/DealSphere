import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/deal_model.dart';
import '../../logic/interests/interests_bloc.dart';
import '../../logic/interests/interests_event.dart';
import '../../logic/interests/interests_state.dart';
import '../theme/app_theme.dart';
import '../widgets/roi_chart.dart';

class DealDetailScreen extends StatelessWidget {
  final DealModel deal;

  const DealDetailScreen({super.key, required this.deal});

  Color get _riskColor {
    switch (deal.riskLevel) {
      case 'Low':
        return AppColors.success;
      case 'High':
        return AppColors.danger;
      default:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          deal.companyName,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header card ──────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // chips row — Wrap so they never overflow
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          deal.industry,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: (deal.status == 'Open'
                                  ? AppColors.success
                                  : AppColors.textSecondary)
                              .withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          deal.status,
                          style: TextStyle(
                            color:
                                deal.status == 'Open'
                                    ? AppColors.success
                                    : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // metrics row — each box in Expanded so they share width equally
                  Row(
                    children: [
                      Expanded(
                        child: _MetricBox(
                          label: 'Investment',
                          value:
                              '₹${(deal.investmentRequired / 100000).toStringAsFixed(0)}L',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _MetricBox(
                          label: 'Expected ROI',
                          value: '${deal.expectedROI}%',
                          valueColor: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _MetricBox(
                          label: 'Risk',
                          value: deal.riskLevel,
                          valueColor: _riskColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Company Overview ──────────────────────────────────
            _SectionTitle('Company Overview'),
            const SizedBox(height: 10),
            Text(
              deal.overview,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),

            // ── Financial Highlights ──────────────────────────────
            _SectionTitle('Financial Highlights'),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.bar_chart_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      deal.financialHighlights,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        height: 1.6,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── ROI Projection Chart ──────────────────────────────
            _SectionTitle('ROI Projection (6 Months)'),
            const SizedBox(height: 10),
            ROIChart(projections: deal.roiProjection),
            const SizedBox(height: 20),

            // ── Risk Analysis ─────────────────────────────────────
            _SectionTitle('Risk Analysis'),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _riskColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _riskColor.withOpacity(0.25)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.shield_outlined, color: _riskColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      deal.riskExplanation,
                      style: TextStyle(
                        color: _riskColor,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── Interested Button ─────────────────────────────────
            BlocBuilder<InterestsBloc, InterestsState>(
              builder: (context, state) {
                final isInterested = state.isInterested(deal.id);
                return Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color:
                            isInterested
                                ? AppColors.success.withOpacity(0.12)
                                : AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            isInterested
                                ? Border.all(color: AppColors.success)
                                : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            context.read<InterestsBloc>().add(
                              InterestToggled(deal.id),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isInterested
                                      ? 'Removed from your interests'
                                      : 'Added to your interests!',
                                ),
                                backgroundColor:
                                    isInterested
                                        ? AppColors.textSecondary
                                        : AppColors.success,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isInterested
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_border_rounded,
                                  color:
                                      isInterested
                                          ? AppColors.success
                                          : Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isInterested
                                      ? "You're Interested"
                                      : "I'm Interested",
                                  style: TextStyle(
                                    color:
                                        isInterested
                                            ? AppColors.success
                                            : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (isInterested) ...[
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          context.read<InterestsBloc>().add(
                            InterestToggled(deal.id),
                          );
                        },
                        child: const Text(
                          'Remove Interest',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _MetricBox({
    required this.label,
    required this.value,
    this.valueColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
