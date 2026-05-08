abstract class DealsEvent {}

class DealsFetched extends DealsEvent {}

class DealsSearchChanged extends DealsEvent {
  final String query;
  DealsSearchChanged(this.query);
}

class DealsFilterChanged extends DealsEvent {
  final String? industry;
  final String? riskLevel;
  final double? minROI;
  final double? maxROI;

  DealsFilterChanged({this.industry, this.riskLevel, this.minROI, this.maxROI});
}

class DealsFilterCleared extends DealsEvent {}
