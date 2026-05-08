import '../../data/models/deal_model.dart';

abstract class DealsState {}

class DealsInitial extends DealsState {}

class DealsLoading extends DealsState {}

class DealsLoaded extends DealsState {
  final List<DealModel> allDeals;
  final List<DealModel> filteredDeals;
  final String searchQuery;
  final String? selectedIndustry;
  final String? selectedRiskLevel;
  final double? minROI;
  final double? maxROI;

  DealsLoaded({
    required this.allDeals,
    required this.filteredDeals,
    this.searchQuery = '',
    this.selectedIndustry,
    this.selectedRiskLevel,
    this.minROI,
    this.maxROI,
  });

  bool get hasActiveFilters =>
      selectedIndustry != null ||
      selectedRiskLevel != null ||
      minROI != null ||
      maxROI != null;

  DealsLoaded copyWith({
    List<DealModel>? filteredDeals,
    String? searchQuery,
    String? selectedIndustry,
    String? selectedRiskLevel,
    double? minROI,
    double? maxROI,
    bool clearFilters = false,
  }) {
    return DealsLoaded(
      allDeals: allDeals,
      filteredDeals: filteredDeals ?? this.filteredDeals,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedIndustry:
          clearFilters ? null : (selectedIndustry ?? this.selectedIndustry),
      selectedRiskLevel:
          clearFilters ? null : (selectedRiskLevel ?? this.selectedRiskLevel),
      minROI: clearFilters ? null : (minROI ?? this.minROI),
      maxROI: clearFilters ? null : (maxROI ?? this.maxROI),
    );
  }
}

class DealsError extends DealsState {
  final String message;
  DealsError(this.message);
}
