import 'package:dealsphere/presentation/utils/transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/auth/auth_bloc.dart';
import '../../logic/auth/auth_event.dart';
import '../../logic/deals/deals_bloc.dart';
import '../../logic/deals/deals_event.dart';
import '../../logic/deals/deals_state.dart';
import '../../logic/interests/interests_bloc.dart';
import '../../logic/interests/interests_state.dart';
import '../theme/app_theme.dart';
import '../widgets/deal_card.dart';
import '../widgets/filter_sheet.dart';
import 'deal_detail_screen.dart';
import 'my_interests_screen.dart';

class DealListScreen extends StatefulWidget {
  const DealListScreen({super.key});

  @override
  State<DealListScreen> createState() => _DealListScreenState();
}

class _DealListScreenState extends State<DealListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<DealsBloc>().add(DealsFetched());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.trending_up_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'DealFlow',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_rounded, color: AppColors.primary),
            onPressed:
                () => Navigator.push(
                  context,
                  AppTransitions.slideRightRoute(const MyInterestsScreen()),
                ),
          ),
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.textSecondary,
            ),
            onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search + Filter bar
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Search companies...',
                      hintStyle: TextStyle(color: AppColors.textSecondary),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: AppColors.textSecondary,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged:
                        (q) => context.read<DealsBloc>().add(
                          DealsSearchChanged(q),
                        ),
                  ),
                ),
                const SizedBox(width: 10),
                BlocBuilder<DealsBloc, DealsState>(
                  builder: (context, state) {
                    final hasFilters =
                        state is DealsLoaded && state.hasActiveFilters;
                    return GestureDetector(
                      onTap:
                          () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder:
                                (_) => BlocProvider.value(
                                  value: context.read<DealsBloc>(),
                                  child: const FilterSheet(),
                                ),
                          ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              hasFilters ? AppColors.primary : AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color:
                              hasFilters
                                  ? Colors.white
                                  : AppColors.textSecondary,
                          size: 20,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Deal list
          Expanded(
            child: BlocBuilder<DealsBloc, DealsState>(
              builder: (context, dealState) {
                if (dealState is DealsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (dealState is DealsError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.danger,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          dealState.message,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (dealState is DealsLoaded) {
                  final deals = dealState.filteredDeals;

                  if (deals.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            color: AppColors.textSecondary,
                            size: 48,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No deals found',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    );
                  }

                  return BlocBuilder<InterestsBloc, InterestsState>(
                    builder: (context, interestState) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: deals.length,
                        itemBuilder: (context, index) {
                          final deal = deals[index];
                          final isInterested = interestState.interestedDealIds
                              .contains(deal.id);
                          return DealCard(
                            deal: deal,
                            isInterested: isInterested,
                            onTap:
                                () => Navigator.push(
                                  context,
                                  AppTransitions.slideUpRoute(
                                    DealDetailScreen(deal: deal),
                                  ),
                                ),
                          );
                        },
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
