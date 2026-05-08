import 'package:dealsphere/presentation/utils/transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/deal_model.dart';
import '../../logic/deals/deals_bloc.dart';
import '../../logic/deals/deals_state.dart';
import '../../logic/interests/interests_bloc.dart';
import '../../logic/interests/interests_event.dart';
import '../../logic/interests/interests_state.dart';
import '../theme/app_theme.dart';
import '../widgets/deal_card.dart';
import 'deal_detail_screen.dart';

class MyInterestsScreen extends StatelessWidget {
  const MyInterestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text(
          'My Interests',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: BlocBuilder<InterestsBloc, InterestsState>(
        builder: (context, interestState) {
          final ids = interestState.interestedDealIds;

          if (ids.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bookmark_border_rounded,
                    color: AppColors.textSecondary,
                    size: 56,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No interests yet",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Tap \"I'm Interested\" on any deal\nto save it here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          }

          return BlocBuilder<DealsBloc, DealsState>(
            builder: (context, dealState) {
              if (dealState is! DealsLoaded) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              final interestedDeals =
                  dealState.allDeals.where((d) => ids.contains(d.id)).toList();

              return Column(
                children: [
                  // Summary banner
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.bookmark_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${interestedDeals.length} deal${interestedDeals.length == 1 ? '' : 's'} saved',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: interestedDeals.length,
                      itemBuilder: (context, index) {
                        final deal = interestedDeals[index];
                        return Dismissible(
                          key: Key(deal.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: AppColors.danger.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.danger.withOpacity(0.3),
                              ),
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: AppColors.danger,
                            ),
                          ),
                          onDismissed: (_) {
                            context.read<InterestsBloc>().add(
                              InterestToggled(deal.id),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${deal.companyName} removed'),
                                backgroundColor: AppColors.textSecondary,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: DealCard(
                            deal: deal,
                            isInterested: true,
                            onTap:
                                () => Navigator.push(
                                  context,
                                  AppTransitions.slideUpRoute(
                                    DealDetailScreen(deal: deal),
                                  ),
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
