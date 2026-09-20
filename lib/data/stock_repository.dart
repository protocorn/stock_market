import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:stock_market/models/stock.dart';

class StockRepository {
  StockRepository._();
  static final StockRepository instance = StockRepository._();

  static const _assetPath = 'assets/data/mock_stocks.json';

  MockMarketData? _cache;

  Future<MockMarketData> load() async {
    if (_cache != null) return _cache!;

    final raw = await rootBundle.loadString(_assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    _cache = MockMarketData.fromJson(json);
    return _cache!;
  }

  Future<Stock?> getById(String id) async {
    final data = await load();
    return data.byId(id);
  }
}
