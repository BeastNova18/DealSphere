abstract class InterestsEvent {}

class InterestToggled extends InterestsEvent {
  final String dealId;
  InterestToggled(this.dealId);
}

class InterestsLoaded extends InterestsEvent {}
