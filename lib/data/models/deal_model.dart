class DealModel {
  final String id;
  final String companyName;
  final String industry;
  final double investmentRequired;
  final double expectedROI;
  final String riskLevel; // Low / Medium / High
  final String status; // Open / Closed
  final String overview;
  final String financialHighlights;
  final String riskExplanation;
  final List<double> roiProjection; // 6 months mock data

  const DealModel({
    required this.id,
    required this.companyName,
    required this.industry,
    required this.investmentRequired,
    required this.expectedROI,
    required this.riskLevel,
    required this.status,
    required this.overview,
    required this.financialHighlights,
    required this.riskExplanation,
    required this.roiProjection,
  });
}
