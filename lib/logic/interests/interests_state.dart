class InterestsState {
  final Set<String> interestedDealIds;

  const InterestsState({this.interestedDealIds = const {}});

  InterestsState copyWith({Set<String>? interestedDealIds}) {
    return InterestsState(
      interestedDealIds: interestedDealIds ?? this.interestedDealIds,
    );
  }

  bool isInterested(String dealId) => interestedDealIds.contains(dealId);
}
