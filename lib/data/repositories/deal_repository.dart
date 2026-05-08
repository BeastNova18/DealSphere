import 'dart:async';
import '../models/deal_model.dart';

class DealRepository {
  Future<List<DealModel>> fetchDeals() async {
    // Simulated API delay
    await Future.delayed(const Duration(seconds: 2));

    return [
      DealModel(
        id: '1',
        companyName: 'GreenTech Ventures',
        industry: 'CleanTech',
        investmentRequired: 5000000,
        expectedROI: 22.5,
        riskLevel: 'Low',
        status: 'Open',
        overview:
            'GreenTech is a solar energy startup focused on rural electrification across India.',
        financialHighlights: 'Revenue: ₹1.2Cr | EBITDA: 18% | YoY Growth: 34%',
        riskExplanation:
            'Low risk due to government backing and existing contracts.',
        roiProjection: [5, 8, 12, 15, 19, 22.5],
      ),
      DealModel(
        id: '2',
        companyName: 'FinEdge Capital',
        industry: 'FinTech',
        investmentRequired: 10000000,
        expectedROI: 35.0,
        riskLevel: 'High',
        status: 'Open',
        overview:
            'FinEdge builds B2B lending infrastructure for NBFCs and co-operative banks.',
        financialHighlights: 'Revenue: ₹4.5Cr | EBITDA: 22% | YoY Growth: 67%',
        riskExplanation:
            'High risk due to regulatory uncertainty in digital lending space.',
        roiProjection: [8, 14, 20, 25, 30, 35],
      ),
      DealModel(
        id: '3',
        companyName: 'MediCore AI',
        industry: 'HealthTech',
        investmentRequired: 7500000,
        expectedROI: 28.0,
        riskLevel: 'Medium',
        status: 'Open',
        overview:
            'MediCore uses AI diagnostics to assist tier-2 city hospitals with radiology.',
        financialHighlights: 'Revenue: ₹2.1Cr | EBITDA: 20% | YoY Growth: 51%',
        riskExplanation:
            'Medium risk — strong tech but depends on hospital adoption speed.',
        roiProjection: [4, 9, 14, 19, 24, 28],
      ),
      DealModel(
        id: '4',
        companyName: 'AgriLink Solutions',
        industry: 'AgriTech',
        investmentRequired: 3000000,
        expectedROI: 18.0,
        riskLevel: 'Low',
        status: 'Closed',
        overview:
            'AgriLink connects farmers directly to commodity buyers using a mobile platform.',
        financialHighlights: 'Revenue: ₹80L | EBITDA: 14% | YoY Growth: 28%',
        riskExplanation:
            'Low risk with steady rural demand and established user base.',
        roiProjection: [3, 6, 9, 12, 15, 18],
      ),
      DealModel(
        id: '5',
        companyName: 'SpaceRoute Logistics',
        industry: 'Logistics',
        investmentRequired: 12000000,
        expectedROI: 31.0,
        riskLevel: 'Medium',
        status: 'Open',
        overview:
            'SpaceRoute is building a drone-based last-mile delivery network for metros.',
        financialHighlights: 'Revenue: ₹3.8Cr | EBITDA: 17% | YoY Growth: 44%',
        riskExplanation:
            'Medium risk — drone regulations are evolving but positively.',
        roiProjection: [6, 11, 17, 22, 27, 31],
      ),
    ];
  }
}
