import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/deal_model.dart';
import '../../data/repositories/deal_repository.dart';
import 'deals_event.dart';
import 'deals_state.dart';

class DealsBloc extends Bloc<DealsEvent, DealsState> {
  final DealRepository _repository;

  DealsBloc(this._repository) : super(DealsInitial()) {
    on<DealsFetched>(_onFetched);
    on<DealsSearchChanged>(_onSearchChanged);
    on<DealsFilterChanged>(_onFilterChanged);
    on<DealsFilterCleared>(_onFilterCleared);
  }

  Future<void> _onFetched(DealsFetched event, Emitter emit) async {
    emit(DealsLoading());
    try {
      final deals = await _repository.fetchDeals();
      emit(DealsLoaded(allDeals: deals, filteredDeals: deals));
    } catch (e) {
      emit(DealsError('Failed to load deals. Please try again.'));
    }
  }

  void _onSearchChanged(DealsSearchChanged event, Emitter emit) {
    if (state is! DealsLoaded) return;
    final current = state as DealsLoaded;
    final filtered = _applyFilters(
      current.allDeals,
      query: event.query,
      industry: current.selectedIndustry,
      riskLevel: current.selectedRiskLevel,
      minROI: current.minROI,
      maxROI: current.maxROI,
    );
    emit(current.copyWith(filteredDeals: filtered, searchQuery: event.query));
  }

  void _onFilterChanged(DealsFilterChanged event, Emitter emit) {
    if (state is! DealsLoaded) return;
    final current = state as DealsLoaded;
    final filtered = _applyFilters(
      current.allDeals,
      query: current.searchQuery,
      industry: event.industry ?? current.selectedIndustry,
      riskLevel: event.riskLevel ?? current.selectedRiskLevel,
      minROI: event.minROI ?? current.minROI,
      maxROI: event.maxROI ?? current.maxROI,
    );
    emit(
      current.copyWith(
        filteredDeals: filtered,
        selectedIndustry: event.industry ?? current.selectedIndustry,
        selectedRiskLevel: event.riskLevel ?? current.selectedRiskLevel,
        minROI: event.minROI ?? current.minROI,
        maxROI: event.maxROI ?? current.maxROI,
      ),
    );
  }

  void _onFilterCleared(DealsFilterCleared event, Emitter emit) {
    if (state is! DealsLoaded) return;
    final current = state as DealsLoaded;
    final filtered = _applyFilters(
      current.allDeals,
      query: current.searchQuery,
    );
    emit(current.copyWith(filteredDeals: filtered, clearFilters: true));
  }

  List<DealModel> _applyFilters(
    List<DealModel> deals, {
    String query = '',
    String? industry,
    String? riskLevel,
    double? minROI,
    double? maxROI,
  }) {
    return deals.where((deal) {
      final matchesSearch =
          query.isEmpty ||
          deal.companyName.toLowerCase().contains(query.toLowerCase());
      final matchesIndustry = industry == null || deal.industry == industry;
      final matchesRisk = riskLevel == null || deal.riskLevel == riskLevel;
      final matchesMinROI = minROI == null || deal.expectedROI >= minROI;
      final matchesMaxROI = maxROI == null || deal.expectedROI <= maxROI;
      return matchesSearch &&
          matchesIndustry &&
          matchesRisk &&
          matchesMinROI &&
          matchesMaxROI;
    }).toList();
  }
}
