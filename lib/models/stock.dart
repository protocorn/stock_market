class ScorePart {
  const ScorePart({
    required this.score,
    required this.detail,
  });

  final int score;
  final String detail;

  factory ScorePart.fromJson(Map<String, dynamic> json) {
    return ScorePart(
      score: json['score'] as int,
      detail: json['detail'] as String,
    );
  }
}

class PeerSnapshot {
  const PeerSnapshot({
    required this.name,
    required this.score,
    required this.pe,
    required this.roe,
    required this.isSelf,
  });

  final String name;
  final int score;
  final double pe;
  final double roe;
  final bool isSelf;

  factory PeerSnapshot.fromJson(Map<String, dynamic> json) {
    return PeerSnapshot(
      name: json['name'] as String,
      score: json['score'] as int,
      pe: (json['pe'] as num).toDouble(),
      roe: (json['roe'] as num).toDouble(),
      isSelf: json['isSelf'] as bool? ?? false,
    );
  }
}

class FinancialsSnapshot {
  const FinancialsSnapshot({
    required this.years,
    required this.revenue,
    required this.netProfit,
    required this.opMargin,
  });

  final List<String> years;
  final List<String> revenue;
  final List<String> netProfit;
  final List<String> opMargin;

  factory FinancialsSnapshot.fromJson(Map<String, dynamic> json) {
    return FinancialsSnapshot(
      years: (json['years'] as List).cast<String>(),
      revenue: (json['revenue'] as List).cast<String>(),
      netProfit: (json['netProfit'] as List).cast<String>(),
      opMargin: (json['opMargin'] as List).cast<String>(),
    );
  }
}

class Stock {
  const Stock({
    required this.id,
    required this.ticker,
    required this.name,
    required this.price,
    required this.changePercent,
    required this.score,
    required this.previousScore,
    required this.inPortfolio,
    required this.recommendationInsight,
    required this.summaryQuote,
    required this.statusTag,
    required this.summaryDescription,
    required this.fundamentals,
    required this.technicals,
    required this.news,
    required this.peers,
    required this.financials,
    required this.financialInsight,
    required this.eventTitle,
    required this.eventTag,
    required this.eventDescription,
    required this.forYouInsight,
  });

  final String id;
  final String ticker;
  final String name;
  final double price;
  final double changePercent;
  final int score;
  final int previousScore;
  final bool inPortfolio;
  final String recommendationInsight;
  final String summaryQuote;
  final String statusTag;
  final String summaryDescription;
  final ScorePart fundamentals;
  final ScorePart technicals;
  final ScorePart news;
  final List<PeerSnapshot> peers;
  final FinancialsSnapshot financials;
  final String financialInsight;
  final String eventTitle;
  final String eventTag;
  final String eventDescription;
  final String forYouInsight;

  bool get isUp => changePercent >= 0;

  factory Stock.fromJson(Map<String, dynamic> json) {
    final breakdown = json['scoreBreakdown'] as Map<String, dynamic>;
    return Stock(
      id: json['id'] as String,
      ticker: json['ticker'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      changePercent: (json['changePercent'] as num).toDouble(),
      score: json['score'] as int,
      previousScore: json['previousScore'] as int,
      inPortfolio: json['inPortfolio'] as bool? ?? false,
      recommendationInsight: json['recommendationInsight'] as String,
      summaryQuote: json['summaryQuote'] as String,
      statusTag: json['statusTag'] as String,
      summaryDescription: json['summaryDescription'] as String,
      fundamentals: ScorePart.fromJson(
        breakdown['fundamentals'] as Map<String, dynamic>,
      ),
      technicals: ScorePart.fromJson(
        breakdown['technicals'] as Map<String, dynamic>,
      ),
      news: ScorePart.fromJson(breakdown['news'] as Map<String, dynamic>),
      peers: (json['peers'] as List)
          .map((e) => PeerSnapshot.fromJson(e as Map<String, dynamic>))
          .toList(),
      financials: FinancialsSnapshot.fromJson(
        json['financials'] as Map<String, dynamic>,
      ),
      financialInsight: json['financialInsight'] as String,
      eventTitle: json['eventTitle'] as String,
      eventTag: json['eventTag'] as String,
      eventDescription: json['eventDescription'] as String,
      forYouInsight: json['forYouInsight'] as String,
    );
  }
}

class MockMarketData {
  const MockMarketData({
    required this.recommendationId,
    required this.defaultWatchlistIds,
    required this.stocks,
  });

  final String recommendationId;
  final List<String> defaultWatchlistIds;
  final List<Stock> stocks;

  Stock? byId(String id) {
    for (final stock in stocks) {
      if (stock.id == id) return stock;
    }
    return null;
  }

  factory MockMarketData.fromJson(Map<String, dynamic> json) {
    return MockMarketData(
      recommendationId: json['recommendationId'] as String,
      defaultWatchlistIds: (json['defaultWatchlistIds'] as List).cast<String>(),
      stocks: (json['stocks'] as List)
          .map((e) => Stock.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
